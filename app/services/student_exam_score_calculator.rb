class StudentExamScoreCalculator
  attr_reader :student_exam, :exam

  def initialize(student_exam_id)
    @student_exam = StudentExam.includes(student_exam_answers: :question, exam: :questions).where(id: student_exam_id).first
    @exam = student_exam.exam
  end

  def calculate
    sections.each do |section|
      @current_section = section
      counts = jee_correct_incorrect_counts
      StudentExamSummary.create!(
        student_exam_id: @student_exam.id,
        answered: answered,
        not_answered: not_answered,
        correct: counts[:correct_count],
        incorrect: counts[:in_correct_count],
        score: score(counts),
        total_score: total_score,
        no_of_questions: no_of_questions,
        section_id: @current_section.id,
        input_questions_present: counts[:input_questions_present],
        correct_input_questions: counts[:input_correct_count],
        incorrect_input_questions: counts[:input_incorrect_count],
      )
    end
  end

  private

  def sections
    @_sections ||= exam.sections
  end

  def se_sea
    @se_sea ||= student_exam.student_exam_answers.includes(:option, question: [:options])
  end

  def no_of_questions
    begin
      exam.questions.select do |question|
        question.section_id == @current_section.id
      end.count
    end
  end

  def answered
    count = 0
    se_sea.each do |sea|
      next if sea.option_id == 0
      next if sea.question.input? && sea.ans.blank?
      count += 1 if sea.question.section_id == @current_section.id
    end
    count
  end

  def not_answered
    no_of_questions - answered
  end

  def correct
    begin
      se_sea.select do |sea|
        sea.question.section_id == @current_section.id && sea.option.is_answer
      end.size
    end
  end

  def incorrect
    answered - correct
  end

  def jee_correct_incorrect_counts
    correct_count, in_correct_count = 0, 0
    input_correct_count, input_incorrect_count = 0, 0
    input_questions_present = false
    se_sea.select do |sea|
      next if sea.option_id == 0
      next if sea.question.section_id != @current_section.id

      if sea.question.single_select?
        sea.option.is_answer ? correct_count += 1 : in_correct_count += 1
      elsif sea.question.input?
        if sea.question.options.first.data.to_f.round(2) == sea.ans.to_f.round(2)
          input_correct_count += 1
        else
          input_incorrect_count += 1
        end
        input_questions_present = true
      end
    end
    {
      correct_count: correct_count,
      in_correct_count: in_correct_count,
      input_correct_count: input_correct_count,
      input_incorrect_count: input_incorrect_count,
      input_questions_present: input_questions_present
    }
  end

  def cet_correct_incorrect_counts
    correct_count, in_correct_count = 0, 0
    se_sea.select do |sea|
      next if sea.option_id == 0
      next if sea.question.section_id != @current_section.id
        sea.option.is_answer ? correct_count += 1 : in_correct_count +=1
    end
    { correct_count: correct_count, in_correct_count: in_correct_count }
  end

  def score(counts)
    exam_section = ExamSection.find_by(exam: exam, section: @current_section)
    (counts[:correct_count] * exam_section.positive_marks) +
      (counts[:in_correct_count] * exam_section.negative_marks) +
      (counts[:input_correct_count] * exam_section.positive_marks)
  end

  def total_score
    exam_section = ExamSection.find_by(exam: exam, section: @current_section)
    exam_section.positive_marks * no_of_questions
  end
end
