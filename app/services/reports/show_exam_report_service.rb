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
      student_exam_ids = StudentExam.where(exam_id: exam_id).map(&:id)
      student_exam_summaries = StudentExamSummary.includes(student_exam: :student).where(student_exam_id: student_exam_ids)
      @student_exam_summaries_hash = {}
      student_exam_summaries.each do |student_exam_summary|
        roll_number = student_exam_summary.student_exam.student.roll_number
        @student_exam_summaries_hash[roll_number] ||= {
            roll_number: roll_number,
            name: student_exam_summary.student_exam.student.name
        }
        @student_exam_summaries_hash[roll_number][:score] = @student_exam_summaries_hash[roll_number][:score].to_s.to_i + student_exam_summary.score.to_i
        @student_exam_summaries_hash[roll_number][:correct] = @student_exam_summaries_hash[roll_number][:score].to_s.to_i + student_exam_summary.score.to_i
        @student_exam_summaries_hash[roll_number][:incorrect] = @student_exam_summaries_hash[roll_number][:score].to_s.to_i + student_exam_summary.score.to_i
      end
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
      @student_exam_summaries_hash.sort_by!{|h| -h[:score]}.each_with_index{|h, index| h.merge!({rank: (index + 1)})}
      if q.present? && q[:s] == 'rank asc'
        @student_exam_summaries_hash.reverse!
      end
    end
  end
end
