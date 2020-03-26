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

      model_ans_data = {}
      model_ans_data[:exam_id] = exam_id
      model_ans_data[:exam_id] = exam_id
      indexed_questions = exam.questions.includes(:options).index_by(&:id)

    rescue ModelAnsError, StandardError => ex
      return false
    end

  end
end
