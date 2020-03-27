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
      return exam_model_ans if exam_model_ans.present?

      exam = Exam.find exam_id
      return false unless exam

      questions = {}
      es_by_id = exam.exam_sections.index_by(&:section_id)
      exam.questions.includes(:options).each do |question|
        exam_section = es_by_id[question.section_id]
        questions[question.id] = {
          type: question.question_type,
          ans: question.options.find_by(is_answer: true).id,
          pm: exam_section.positive_marks,
          nm: exam_section.negative_marks}
      end
      model_ans_data = {
        exam_id: exam_id,
        questions: questions,
      }
      REDIS_CACHE.set(cache_key, model_ans_data.to_json)
      REDIS_CACHE.get(cache_key)
    rescue ModelAnsError, StandardError => ex
      false
    end
  end
end
