# == Schema Information
#
# Table name: omr_student_tests
#
#  id             :bigint(8)        not null, primary key
#  data           :jsonb
#  rank           :integer
#  score          :integer          default(0)
#  student_ans    :jsonb
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  child_test_id  :integer
#  omr_student_id :bigint(8)
#  omr_test_id    :bigint(8)
#
# Indexes
#
#  index_omr_student_tests_on_omr_student_id                  (omr_student_id)
#  index_omr_student_tests_on_omr_student_id_and_omr_test_id  (omr_student_id,omr_test_id) UNIQUE
#  index_omr_student_tests_on_omr_test_id                     (omr_test_id)
#

class Omr::StudentTest < ApplicationRecord
  belongs_to :omr_student, class_name: 'Omr::Student'
  belongs_to :omr_test, class_name: 'Omr::Test'

  def self.get_m_factor(total_marks)
    return 4 if total_marks == 180
    return 2 if total_marks == 360
    return 1
  end

  def self.get_student_summary(student_id)
    student_tests = Omr::StudentTest.where(omr_student_id: student_id)
    scores = []
    cumm_accuracy, cumm_wrong, cumm_skip = [], [], []
    data_per_subject = {}
    summary_per_subject = {}

    student_tests.includes(:omr_test).each do |student_test|
      next if student_test.omr_test.blank?
      next if student_test.data.blank?

      scores << (student_test.score * 100)/student_test.omr_test.total_marks.to_f
      m_factor = get_m_factor(student_test.omr_test.total_marks)

      student_test.data.each do |sub, sub_data|
        next if sub == 'single_subject'
        sub = Omr::Test.get_subject_code(sub)

        data_per_subject[sub] ||= {
          scores: [],
          accuracy: [],
          correct: [],
          wrong: [],
          skip: []
        }

        data_per_subject[sub][:scores] << sub_data['score'] * m_factor
        data_per_subject[sub][:accuracy] << (sub_data['correct_count'] * 100) / (sub_data['correct_count'].to_i + sub_data['wrong_count'].to_i).to_f
        data_per_subject[sub][:correct] << sub_data['correct_count'] * m_factor
        data_per_subject[sub][:wrong] << sub_data['wrong_count'] * m_factor
        data_per_subject[sub][:skip] << sub_data['skip_count'] * m_factor
      end
    end

    data_per_subject.each do |sub, sub_data|
      avg_score = sub_data[:scores].sum/sub_data[:scores].size
      avg_accuracy = sub_data[:accuracy].sum/sub_data[:accuracy].size
      avg_correct = sub_data[:correct].sum/sub_data[:correct].size
      avg_wrong = sub_data[:wrong].sum/sub_data[:wrong].size
      avg_skip = sub_data[:skip].sum/sub_data[:skip].size
      cumm_accuracy << avg_accuracy
      cumm_wrong << avg_wrong
      cumm_skip << avg_skip

      summary_per_subject[sub] ||= {
        avg_score: avg_score,
        avg_accuracy: avg_accuracy,
        avg_correct: avg_correct,
        avg_wrong: avg_wrong,
        avg_skip: avg_skip
      }
    end

    return summary_per_subject.merge!(
      avg_score: scores.sum/scores.size.to_f,
      accuracy: cumm_accuracy.sum/cumm_accuracy.size.to_f,
      wrong: cumm_wrong.sum,
      skip: cumm_skip.sum
    )
  end
end

# Omr::StudentTest.get_student_summary(1955)
