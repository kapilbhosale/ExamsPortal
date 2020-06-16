class ShowExamReportError < StandardError; end

module Reports
  class ExamCsvReportService
    attr_reader :exam

    def initialize(exam_id)
      @exam = Exam.find_by(id: exam_id)
    end

    # this is a backup mechanism, if by any changes we have sync data but not summary data
    # this method will add sync data to summary
    def considerDangligDataInSummary
      not_considered_se_ids = StudentExamAnswer.includes(:student_exam).where(student_exams: {exam_id: exam.id}).pluck(:student_exam_id).uniq
      considered_se_ids = StudentExamSummary.includes(:student_exam).where(student_exams: {exam_id: exam.id}).pluck(:student_exam_id).uniq
      (not_considered_se_ids - considered_se_ids).each do |se_id|
        StudentExamScoreCalculator.new(se_id).calculate
      end
    end

    def syn_data_to_se
      ses_ids_to_delete = []
      exam.batches.each do |batch|
        student_ids = batch.students.ids
        StudentExamSync.where(student_id: student_ids, exam_id: exam.id).find_each do |ses|
          Students::SyncService.new(ses.student_id, exam.id, ses.sync_data).call
          ses_ids_to_delete << ses.id
        end
      end
      StudentExamSync.where(id: ses_ids_to_delete).delete_all
    end

    def prepare_report
      syn_data_to_se()

      results = {}
      considerDangligDataInSummary()
      StudentExamSummary.includes(:student_exam).where(student_exams: {exam_id: exam.id}).all.group_by(&:student_exam_id).each do |student_exam_id, summary|
        summary.each do |s|
          results[student_exam_id] ||= {}
          results[student_exam_id][s.section_id] = {
              no_of_questions: s.no_of_questions,
              answered: s.answered,
              not_answered: s.not_answered,
              correct: s.correct,
              incorrect: s.incorrect,
              score: s.score
          }
        end
      end

      student_exams_by_id = StudentExam.includes(student: [:batches]).all.index_by(&:id)

      data = {}
      results.each do |student_exam_id, result|
        student = student_exams_by_id[student_exam_id].student
        next if student.blank?

        data[student_exam_id] ||= {}
        data[student_exam_id][:roll_number] = student.roll_number
        data[student_exam_id][:name] = student.name
        data[student_exam_id][:parent_mobile] = student.parent_mobile
        data[student_exam_id][:batch] = student.batches.pluck(:name).first
        result.each do |section_id, res|
          data[student_exam_id][section_id] ||= res
        end
      end

      exam_section_ids = exam.sections.order(:id).ids

      CSV.generate(headers: true) do |csv|
        csv << csv_headers
        csv <<
        data.each do |_, row|
          total = {
              no_of_questions: 0,
              answered: 0,
              not_answered: 0,
              correct: 0,
              incorrect: 0,
              score: 0
          }
          csv_row = [
              row[:roll_number],
              row[:name],
              row[:parent_mobile],
              row[:batch]]

              exam_section_ids.each do |sec_id|
                section_columns = []
                total.keys.each do |total_key|
                  total[total_key] = total[total_key] + row[sec_id][total_key]
                  section_columns << row[sec_id][total_key]
                end
               csv_row += section_columns
              end
          total_data = []
          total.each do |key, val|
            total_data << total[key]
          end
          csv_row += total_data
          csv << csv_row
        end

        Student.where(id: exam.un_appeared_student_ids).includes(:batches).find_each do |student|
          csv << [student.roll_number, student.name, student.parent_mobile, student.batches.pluck(:name).join(', ')]
        end

      end
    rescue ShowExamReportError, ActiveRecord::RecordInvalid => ex
      nil
    end

    private

    def csv_headers
      headers = ['Roll Number', 'Student Name', 'Parent Mobile', 'Batch']
      exam.sections.order(:id).each do |section|
        section_name = section.name
        headers += ["#{section_name}_no_of_questions",
         "#{section_name}_answered",
         "#{section_name}_not_answered",
         "#{section_name}_correct",
         "#{section_name}_incorrect",
         "#{section_name}_score"]
      end
      headers + ['total_no_of_questions', 'total_answered', 'total_not_answered', 'total_correct', 'total_incorrect', 'total_score']
    end

    def validate_request
      raise ShowExamReportError, 'Exam does not exists' unless exam_exists?
    end

    def exam_exists?
      StudentExam.where(exam_id: exam_id).exists?
    end
  end
end
