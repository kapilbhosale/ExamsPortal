class ShowExamReportError < StandardError; end

module Reports
  class ShowExamReportService
    attr_reader :exam_id, :q
    def initialize(exam_id, q)
      @exam_id = exam_id
      @q = q
    end

    def prepare_report
      validate_request
      @search = StudentExam.where(exam_id: exam_id).search(q)
      #return {status: true, message: nil, search: @search, student_exams_hash: @student_exams_hash}
      @student_exams = @search.result
      @student_exams_hash = []
      @student_exams.each do |student_exam|
        @student_exams_hash.push({roll_number: student_exam.student.roll_number,
                                  name: student_exam.student.name,
                                  marks: student_exam.correct_answers_count,
                                  correct: student_exam.correct_answers_count,
                                  wrong: student_exam.exam.no_of_questions - student_exam.correct_answers_count
                                  })
      end
      append_student_ranks
      return {status: true, message: nil, search: @search, student_exams_hash: @student_exams_hash}
    rescue ShowExamReportError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise ShowExamReportError, 'Exam does not exists' unless exam_exists?
    end

    def exam_exists?
      StudentExam.where(exam_id: exam_id).present?
    end

    def append_student_ranks
      @student_exams_hash.sort_by{|h| h[:marks]}.reverse.each_with_index{|h, index| h.merge!({rank: (index + 1)})}
      if q.present?
        if q[:s] == 'rank asc'
          @student_exams_hash.reverse!
        end
      end
    end
  end
end
