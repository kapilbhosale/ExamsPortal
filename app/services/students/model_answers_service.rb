class ModelAnswersError < StandardError; end

module Students
  class ModelAnswersService
    attr_reader :student, :exam, :student_exam

    def initialize(student_id, exam_id)
      @student = Student.find(student_id)
      @exam = Exam.find(exam_id)
      @student_exam = StudentExam.find_by(student_id: student.id, exam_id: exam.id)
    end

    def call
      validate_request

      questions_by_section = exam.questions.includes(:options).group_by(&:section_id)
      sections_by_id = Section.all.index_by(&:id)
      all_styles = '' #exam.questions.collect {|x| x.css_style}.join(' ')

      student_ans_by_question = student_exam.student_exam_answers.includes(:option).index_by(&:question_id)

      return {
        status: true,
        data: {
          questions_by_section: questions_by_section,
          sections_by_id: sections_by_id,
          all_styles: all_styles,
          student_ans_by_question: student_ans_by_question
        }
      }

    rescue ModelAnswersError => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise ModelAnswersError, 'Student does not exist'if student.blank?
      raise ModelAnswersError, 'Exam does not exist'if exam.blank?
      raise ModelAnswersError, 'You must submit exam to see model answers'if student_exam.blank?
      raise ModelAnswersError, 'Model answers are not published yet, please wait for admin to publish it.' unless exam.publish_result
    end
  end
end
