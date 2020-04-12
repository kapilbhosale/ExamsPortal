class SyncError < StandardError; end

module Students
  class SyncService
    attr_reader :student, :exam, :student_exam, :questions_data

    def initialize(student_id, exam_id, questions_data)
      @student = Student.find_by(id: student_id)
      @exam = Exam.find_by(id: exam_id)
      @student_exam = StudentExam.find_by(student: student, exam: exam)
      @questions_data = questions_data
    end

    def questions_by_id
      @questions_by_id ||= exam.questions.index_by(&:id)
    end

    def student_exam_answer_by_qid
      @student_exam_answer_by_qid ||=
        StudentExamAnswer.where(student_exam_id: student_exam.id, question_id: questions_by_id.keys).index_by(&:question_id)
    end

    def student_exam_answer_columns
      ["question_id", "option_id", "ans", "question_props", "student_exam_id"]
    end

    def call
      values = []
      questions_data.each do |section, questions|
        questions.each do  |index, input_question|
          input_question = ActiveSupport::HashWithIndifferentAccess.new(input_question)
          question_id = input_question['id'].to_i
          question = questions_by_id[question_id]

          if question.input? || question.single_select?
            student_ans = input_question[:answerProps][:answer].first.strip
          else
            student_ans = input_question[:answerProps][:answer]
          end
          input_question[:answerProps].delete(:answer)
          # next if student_ans.blank?
          # commenting so as to store the ans/question props

          student_exam_answer = student_exam_answer_by_qid[question_id]
          next if question.input? && student_exam_answer&.ans == student_ans
          next if question.single_select? && student_exam_answer&.option_id == student_ans.to_i

          if question.input?
            # student_exam_answer = StudentExamAnswer.find_by(student_exam_id: student_exam.id, question_id: input_question[:id])
            if student_exam_answer
              student_exam_answer.update!(ans: student_ans, question_props: input_question[:answerProps])
            else
              values.push("#{question_id}, NULL, '#{student_ans}', '#{input_question[:answerProps].to_json}'")
            end
          elsif question.single_select?
            # student_exam_answer = StudentExamAnswer.find_by(student_exam_id: student_exam.id, question_id: input_question[:id])
            if student_exam_answer
              student_exam_answer.update!(option_id: student_ans.to_i, question_props: input_question[:answerProps])
            else
              values.push("#{question_id}, #{student_ans.to_i}, NULL, '#{input_question[:answerProps].to_json}'")
            end
          end
        end
      end
      if values.present?
        StudentExamAnswer.bulk_create(student_exam_answer_columns, values, student_exam.id)
      end
      return {sucess: true}
    rescue StandardError => e
      Rails.logger.error("#{e.message} Student_id: #{student.id}")
      return {success: false, errors: []}
    end
  end
end