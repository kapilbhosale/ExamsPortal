class StudentExamScoreCalculator
    attr_reader :student_exam, :exam

    def initialize(student_exam_id)
      @student_exam = StudentExam.includes(student_exam_answers: :question, exam: :questions).where(id: student_exam_id).first
      @exam = student_exam.exam
    end

    def calculate
      sections.each do |section|
        @current_section = section
        StudentExamSummary.create!(
          student_exam_id: @student_exam.id,
          answered: answered,
          not_answered: not_answered,
          correct: correct,
          incorrect: incorrect,
          score: score,
          no_of_questions: no_of_questions,
          section_id: @current_section.id,
        )
      end
    end

    private

    def sections
      @_sections ||= @student_exam.exam.questions.map(&:section).uniq
    end

    def no_of_questions
      begin
        student_exam.exam.questions.select do |question|
          question.section_id == @current_section.id
        end.count
      end
    end

    def answered
      begin
        student_exam.student_exam_answers.select do |sea|
          sea.question.section_id == @current_section.id
        end.count
      end
    end

    def not_answered
      no_of_questions - answered
    end

    def correct
      begin
        student_exam.student_exam_answers.select do |sea|
          sea.question.section_id == @current_section.id && sea.option.is_answer
        end.size
      end
    end

    def incorrect
      answered - correct
    end

    def score
      exam_section = ExamSection.find_by(exam: exam, section: @current_section)
      (correct * exam_section.positive_marks) + (incorrect * exam_section.negative_marks)
    end
end
