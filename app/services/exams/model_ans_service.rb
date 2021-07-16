class ModelAnsError < StandardError; end

  # {
  #   exam_id: 1,
  #   questions: {
  #     1: {type: 'single_choice', ans: option_id, pm: 4, nm: -1},
  #     2: {type: 'single_choice', ans: option_id, pm: 4, nm: -1},
  #     3: {type: 'input', ans: ans, pm: 4, nm: -1},
  #   }
  # }

module Exams
  class ModelAnsService
    attr_reader :exam_id
    def initialize(exam_id)
      @exam_id = exam_id
    end

    def call
      cache_key = "exam_model_ans_#{exam_id}"
      exam_model_ans = REDIS_CACHE.get(cache_key)
      # return exam_model_ans if exam_model_ans.present?

      exam = Exam.find exam_id
      return false unless exam

      questions = {}
      es_by_id = exam.exam_sections.index_by(&:section_id)

      question_ids = exam.questions.order(:id).ids
      true_options_by_q_id = Option.where(question_id: question_ids)
                                   .where(is_answer: true).index_by(&:question_id)

      exam.questions.order(:id).includes(:options).each do |question|
        exam_section = es_by_id[question.section_id]
        questions[question.id] = {
          type: question.question_type,
          ans: model_ans(question, true_options_by_q_id),
          pm: exam_section.positive_marks,
          nm: exam_section.negative_marks
        }
      end
      model_ans_data = {
        exam_id: exam_id,
        questions: questions,
        jee_advance: exam.jee_advance?
      }
      REDIS_CACHE.set(cache_key, model_ans_data.to_json)
      REDIS_CACHE.get(cache_key)
    rescue ModelAnsError, StandardError => ex
      console.log("======================================")
      console.log(ex)
      console.log("======================================")
      false
    end

    def model_ans(question, true_options_by_q_id)
      return question.correct_ans if question.multi_select?

      return true_options_by_q_id[question.id]&.data.to_f.round(2) if question.input?

      true_options_by_q_id[question.id]&.id
    end
  end
end
