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
      @search = StudentExam.where(exam_id: exam_id).joins(:student_exam_summary).search(q)
      student_exam_summaries = @search.result
      @student_exam_summaries_hash = student_exam_summaries.each.map{|student_exam_summary| {
                                  roll_number: student_exam_summary.student.roll_number,
                                  name: student_exam_summary.student.name,
                                  score: student_exam_summary.student_exam_summary.score,
                                  correct: student_exam_summary.student_exam_summary.correct,
                                  incorrect: student_exam_summary.student_exam_summary.incorrect
                                  }}
      append_student_ranks
      return {status: true, message: nil, search: @search, student_exam_summaries_hash: @student_exam_summaries_hash}
    rescue ShowExamReportError, ActiveRecord::RecordInvalid => ex
      return {status: false, message: ex.message}
    end

    private

    def validate_request
      raise ShowExamReportError, 'Exam does not exists' unless exam_exists?
    end

    def exam_exists?
      StudentExam.where(exam_id: exam_id).exists?
    end

    def append_student_ranks
      @student_exam_summaries_hash.sort_by{|h| -h[:score]}.each_with_index{|h, index| h.merge!({rank: (index + 1)})}
      if q.present? && q[:s] == 'rank asc'
        @student_exam_summaries_hash.reverse!
      end
    end
  end
end
