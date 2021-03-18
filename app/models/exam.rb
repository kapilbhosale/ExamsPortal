# == Schema Information
#
# Table name: exams
#
#  id                  :bigint(8)        not null, primary key
#  description         :text
#  exam_available_till :datetime
#  exam_type           :integer          default("jee")
#  is_pr_generated     :boolean          default(FALSE)
#  name                :string           not null
#  negative_marks      :integer          default(-1), not null
#  no_of_questions     :integer
#  positive_marks      :integer          default(4), not null
#  publish_result      :boolean          default(FALSE), not null
#  published           :boolean
#  show_exam_at        :datetime
#  time_in_minutes     :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  org_id              :integer          default(0)
#
# Indexes
#
#  index_exams_on_name    (name)
#  index_exams_on_org_id  (org_id)
#

class Exam < ApplicationRecord
  validates_presence_of :name, :no_of_questions, :time_in_minutes

  has_many :exam_questions, dependent: :destroy
  has_many :questions, through: :exam_questions, dependent: :destroy

  has_many :exam_sections, dependent: :destroy
  has_many :sections, through: :exam_sections, dependent: :destroy

  has_many :exam_batches
  has_many :batches, through: :exam_batches

  belongs_to :org

  enum exam_type: { jee: 0, cet: 1, other: 2, jee_advance: 3 }

  # after_create :send_push_notifications
  # has_one :style, as: :component, dependent: :destroy

  def appeared_student_ids
    StudentExam.where(exam: self).pluck(:student_id)
  end

  def un_appeared_student_ids
    total_student_ids - appeared_student_ids
  end

  def total_student_ids
    batches.map(&:student_ids).flatten
  end

  def total_marks
    _total_marks = REDIS_CACHE.get("exam-total-marks-#{id}")
    return _total_marks.to_i if _total_marks.present?

    _total_marks = exam_sections.inject(0) do |sum, exam_section|
      sum + exam_section.total_marks
    end
    REDIS_CACHE.set("exam-total-marks-#{id}", _total_marks)
    _total_marks.to_i
  end

  def display_image
    return 'bio' if only_biology?
    return 'math' if only_math?
    return 'phy' if only_physics?
    return 'chem' if only_chemistry?
    return 'neet' if neet?
    return 'jee' if jee?

    'general'
  end

  def check_exam(section)
    sections.pluck(:name) == [section]
  end

  def only_biology?
    check_exam('biology')
  end

  def only_math?
    check_exam('maths')
  end

  def only_physics?
    check_exam('physics')
  end

  def only_chemistry?
    check_exam('chemistry')
  end

  def only_general?
    check_exam('general')
  end

  def jee?
    sections.pluck(:name).length > 1 && sections.pluck(:name).include?('maths')
  end

  def neet?
    sections.pluck(:name).length > 1 && sections.pluck(:name).include?('biology')
  end

  def send_push_notifications
    fcm = FCM.new(org.fcm_server_key)
    batches.each do |batch|
      reg_ids = batch.students.where.not(fcm_token: nil).pluck(:fcm_token)
      # response = fcm.send(reg_ids, push_options)
      fcm.send(reg_ids, push_options)
    end
  end

  def push_options
    {
      priority: 'high',
      data: {
        message: "New Exam Added"
      },
      notification: {
        body: 'Please appear for the exam added, Exam will be available for 24 Hrs in new exams section.',
        title: "New Exam Added - '#{self.name}'"
      }
    }
  end

  def prepare_report
    exam = self
    # student_exam_syncs = StudentExamSync.where(exam_id: exam.id)
    # student_exam_summaries = StudentExamSummary.includes(:student_exam).where(student_exams: {exam_id: exam.id})

    # if student_exam_syncs.present? && student_exam_summaries.present?
    #   student_exam_summaries.destroy_all
    # end

    Reports::ExamCsvReportService.new(exam.id).prepare_report
    progress_report_data = {}

    # prepate report by deleting existing reports first.
    ProgressReport.where(exam_id: exam.id).delete_all
    StudentExamSummary.includes(:student_exam, :section).where({student_exams: {exam_id: exam.id}}).find_each do |ses|
      student_exam_key = "sid:#{ses.student_exam.student_id}-exam_id:#{exam.id}"
      progress_report_data[student_exam_key] ||= {
        exam_date: exam.show_exam_at,
        exam_name: exam.name,
        exam_id: exam.id,
        student_id: ses.student_exam.student_id,
        percentage: 0,
        data: {
          ses.section.name => {},
          total: { score: 0, total: 0 }
        }
      }

      # total_score = ses.total_score
      # if total_score.zero?
      exam_section = ExamSection.find_by(exam: exam, section: ses.section)
      total_score = exam_section.total_marks
      # end
      progress_report_data[student_exam_key][:data][ses.section.name] = { score: ses.score, total: total_score }
      progress_report_data[student_exam_key][:data][:total][:score] += ses.score
      progress_report_data[student_exam_key][:data][:total][:total] += total_score
      if progress_report_data[student_exam_key][:data][:total][:total].to_f != 0
        val = 100 * progress_report_data[student_exam_key][:data][:total][:score].to_f / progress_report_data[student_exam_key][:data][:total][:total].to_f
        progress_report_data[student_exam_key][:percentage] = val
      end

    end
    ProgressReport.create(progress_report_data.values)
    rank = 1
    pr_data = ProgressReport.where(exam_id: exam.id).group_by(&:percentage)
    pr_data.sort_by { |k, v| -k }.to_h.each do |_, prs|
      ProgressReport.where(id: prs.collect(&:id)).update_all(rank: rank)
      rank += 1
    end
    exam.is_pr_generated = true
    exam.save
    # delete preparing report id
    REDIS_CACHE.del("pr-report-exam-id-#{exam.id}")
  end
end
