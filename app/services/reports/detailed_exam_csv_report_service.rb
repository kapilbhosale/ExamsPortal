class ShowExamReportError < StandardError; end

module Reports
  class DetailedExamCsvReportService
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
      processed_student_exam_ids = StudentExamSummary.includes(:student_exam).where(student_exams: {exam_id: exam.id}).pluck(:student_exam_id)
      exam.batches.each do |batch|
        student_ids = batch.students.ids
        all_student_exam_ids = StudentExam.where(exam: exam, student_id: student_ids).ids
        unprocessed_student_exam_ids = all_student_exam_ids - processed_student_exam_ids
        unprossed_student_ids = StudentExam.where(id: unprocessed_student_exam_ids).pluck(:student_id)
        StudentExamSync.where(student_id: unprossed_student_ids, exam_id: exam.id).find_each do |ses|
          Students::SyncService.new(ses.student_id, exam.id, ses.sync_data).call
        end
      end
    end

    def get_sync_data
      all_student_ids = []
      exam.batches.each do |batch|
        all_student_ids << batch.students.ids
      end
      all_student_ids = all_student_ids.flatten
      sync_summary_data = {}
      student_exam_ids_index = {}
      StudentExam.where(exam: exam, student_id: all_student_ids).find_each do |student_exam|
        student_exam_ids_index[student_exam.student_id] = student_exam.id
      end
      StudentExamSync.where(student_id: all_student_ids, exam_id: exam.id).find_each do |ses|
        sync_summary_data[student_exam_ids_index[ses.student_id]] ||= {}
        ses.sync_data.each do |_, data|
          data.each do |_, val|
            answerProps = val["answerProps"]
            sync_summary_data[student_exam_ids_index[ses.student_id]][val["id"]] = "#{answerProps['isAnswered'] ? answerProps['answer'].first : '-'}|#{answerProps['visits']}|#{answerProps['timeSpent']}"
          end
        end
      end
      sync_summary_data
    end

    def prepare_report
      syn_data_to_se()

      results = {}
      considerDangligDataInSummary()

      StudentExamSummary.includes(:student_exam).where(student_exams: {exam_id: exam.id}).all.group_by(&:student_exam_id).each do |student_exam_id, summary|
        summary.each do |s|
          results[student_exam_id] ||= {
              no_of_questions: 0,
              answered: 0,
              not_answered: 0,
              correct: 0,
              incorrect: 0,
              score: 0
          }
          results[student_exam_id] = {
              no_of_questions: results[student_exam_id][:no_of_questions] + s.no_of_questions,
              answered: results[student_exam_id][:answered] + s.answered,
              not_answered: results[student_exam_id][:not_answered] + s.not_answered,
              correct: results[student_exam_id][:correct] + s.correct,
              incorrect: results[student_exam_id][:incorrect] + s.incorrect,
              score: results[student_exam_id][:score] + s.score
          }
        end
      end

      student_exams_by_id = StudentExam.includes(student: [:batches]).all.index_by(&:id)

      data = {}
      sync_summary_data = get_sync_data()
      results.each do |student_exam_id, result|
        student = student_exams_by_id[student_exam_id].student
        next if student.blank?

        data[student_exam_id] ||= {}
        data[student_exam_id][:roll_number] = student.roll_number
        data[student_exam_id][:name] = student.name
        data[student_exam_id][:parent_mobile] = student.parent_mobile
        data[student_exam_id][:batch] = student.batches.pluck(:name).first
        data[student_exam_id][:result] = result
      end

      CSV.generate(headers: true) do |csv|
        csv << csv_headers
        csv <<
        data.each do |key, row|
          csv_row = [
            row[:roll_number],
            row[:name],
            row[:parent_mobile],
            row[:batch]
          ]

          exam.sections.order(:id).each do |section|
            section.questions.each_with_index do |question, index|
              csv_row << sync_summary_data[key][question.id.to_s]
            end
          end

          csv_row << row[:result][:no_of_questions]
          csv_row << row[:result][:answered]
          csv_row << row[:result][:not_answered]
          csv_row << row[:result][:correct]
          csv_row << row[:result][:incorrect]
          csv_row << row[:result][:score]

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
        section.questions.each_with_index do |question, index|
          headers << "#{section.name}-#{index+1}[#{question.id}]"
        end
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
