class StudentExamScoreCalculator
  attr_reader :student_exam, :exam

  def initialize(student_exam_id)
    @student_exam = StudentExam.includes(student_exam_answers: :question, exam: :questions).where(id: student_exam_id).first
    @exam = student_exam.exam
  end

  def calculate
    neet_sectional_question_ids()

    sections.each do |section|
      @current_section = section
      @exam_section = ExamSection.find_by(exam: exam, section: @current_section)
      counts = jee_correct_incorrect_counts
      StudentExamSummary.create(
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
        extra_data: {
          multiselect_questions_present: counts[:multiselect_questions_present],
          multi_correct_count: counts[:multi_correct_count],
          multi_incorrect_count: counts[:multi_incorrect_count],
          multi_partial_count: counts[:multi_partial_count],
          multi_mark_total: counts[:multi_mark_total],
          multi_not_solved_count: @exam_section.multi_count - (counts[:multi_correct_count] + counts[:multi_incorrect_count] + counts[:multi_partial_count]),
          input_not_solved_count: @exam_section.input_count - (counts[:input_correct_count] + counts[:input_incorrect_count]),
          posetive_marks: @exam_section.positive_marks,
          negative_marks: @exam_section.negative_marks,
          sec_b_count: counts[:sec_b_count],
          sec_b_correct_count: counts[:sec_b_correct_count],
          sec_b_incorrect_count: counts[:sec_b_incorrect_count],
        }
      )
    end
  end

  private

  def neet_sectional_question_ids
    @neet_data = {}
    return unless exam.neet?

    counter = {}
    exam.questions.order(:id).each do |question|
      @neet_data[question.section_id] ||= {a: [], b: []}
      counter[question.section_id] ||= 1

      if counter[question.section_id] <= 35
        @neet_data[question.section_id][:a] << question.id
      else
        @neet_data[question.section_id][:b] << question.id
      end
      counter[question.section_id] += 1
    end
    @neet_data
  end

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
    multiselect_questions_present = false
    multi_correct_count = 0
    multi_incorrect_count = 0
    multi_partial_count = 0
    multi_mark_total = 0

    sec_b_count = 0
    sec_b_correct_count = 0
    sec_b_incorrect_count = 0

    se_sea.order(:question_id).select do |sea|
      next if sea.option_id == 0
      next if sea.question.section_id != @current_section.id

      if sea.question.single_select?
        sec_b = @neet_data.present? && @neet_data[@current_section.id][:b].include?(sea.question.id)
        if sec_b
          if sec_b_count < 10
            if sea.option.is_answer
              correct_count += 1
              sec_b_correct_count += 1 if sec_b
            else
              in_correct_count += 1
              sec_b_incorrect_count += 1 if sec_b
            end
          end
        else
          if sea.option.is_answer
            correct_count += 1
          else
            in_correct_count += 1
          end
        end
        sec_b_count += 1 if sec_b

      elsif sea.question.input?
        if sea.question.options.first.data.to_f.round(2) == sea.ans.to_f.round(2)
          input_correct_count += 1
        else
          input_incorrect_count += 1
        end
        input_questions_present = true
      elsif sea.question.multi_select?
        multiselect_questions_present = true
        # correct options [] 1,2,
        # users ans array []
        # incorrect in users and -1 ()
        # exact equal = 4
        # your mark -> users ans length.
        model_ans = question_model_ans(sea.question)
        student_ans = student_multi_ans(sea.ans)

        if (student_ans - model_ans).present?
          multi_incorrect_count += 1
          if exam.jee_advance? || exam.jee_paper_2?
            multi_mark_total += -2
          else exam.jee_paper_1?
            multi_mark_total += -1
          end
        elsif student_ans.size == model_ans.size && (student_ans & model_ans).size == model_ans.size
          multi_correct_count += 1
          multi_mark_total += 4
        else
          multi_partial_count += 1
          multi_mark_total += student_ans.length
        end
      end
    end
    {
      correct_count: correct_count,
      in_correct_count: in_correct_count,
      input_correct_count: input_correct_count,
      input_incorrect_count: input_incorrect_count,
      input_questions_present: input_questions_present,
      multiselect_questions_present: multiselect_questions_present,
      multi_correct_count: multi_correct_count,
      multi_incorrect_count: multi_incorrect_count,
      multi_partial_count: multi_partial_count,
      multi_mark_total: multi_mark_total,
      sec_b_count: sec_b_count,
      sec_b_correct_count: sec_b_correct_count,
      sec_b_incorrect_count: sec_b_incorrect_count,
    }
  end

  def question_model_ans(question)
    question.options.where(is_answer: true).ids || []
  end

  def student_multi_ans(ans)
    ans.split(',').map(&:to_i) || []
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
    @exam_section = @exam_section || ExamSection.find_by(exam: exam, section: @current_section)
    (counts[:correct_count] * @exam_section.positive_marks) +
      (counts[:in_correct_count] * @exam_section.negative_marks) +
      (counts[:input_correct_count] * @exam_section.positive_marks) +
      counts[:multi_mark_total]
  end

  def total_score
    @exam_section = @exam_section || ExamSection.find_by(exam: exam, section: @current_section)
    @exam_section.total_marks
  end
end
