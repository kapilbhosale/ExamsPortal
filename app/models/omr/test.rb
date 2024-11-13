# == Schema Information
#
# Table name: omr_tests
#
#  id               :bigint(8)        not null, primary key
#  answer_key       :jsonb
#  branch           :string
#  data             :jsonb
#  db_modified_date :string
#  description      :string
#  is_booklet       :boolean          default(FALSE)
#  is_combine       :boolean          default(FALSE)
#  no_of_questions  :integer          default(0)
#  test_date        :datetime
#  test_name        :string           not null
#  toppers          :jsonb
#  total_marks      :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  old_id           :integer
#  org_id           :bigint(8)
#  parent_id        :integer
#
# Indexes
#
#  index_omr_tests_on_org_id  (org_id)
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#

class Omr::Test < ApplicationRecord
  has_many :omr_batch_tests, class_name: 'Omr::BatchTest', foreign_key: 'omr_test_id'
  has_many :omr_batches, through: :omr_batch_tests

  has_many :omr_student_tests, class_name: 'Omr::StudentTest', foreign_key: 'omr_test_id'
  has_many :omr_students, through: :omr_student_tests

  belongs_to :parent_test, class_name: 'Omr::Test', foreign_key: 'parent_id', optional: true
  has_many :child_tests, class_name: 'Omr::Test', foreign_key: 'parent_id'

  belongs_to :org

  def calculate_rank
    return if self.parent_test.present?

    student_tests = self.omr_student_tests.order(score: :desc)
    current_rank = 0
    current_score = nil
    student_tests.each do |student_test|
      if student_test.score != current_score
        current_score = student_test.score
        current_rank += 1
      end
      student_test.update(rank: current_rank)
    end
  end

  def self.get_subject_code(subject)
    return 'Phy' if ['phy', 'physics'].include?(subject.downcase)
    return 'Chem' if ['chem', 'chemistry'].include?(subject.downcase)
    return 'Bio' if ['bio', 'biology'].include?(subject.downcase)
    return 'Bot' if ['bot', 'botany', 'botony'].include?(subject.downcase)
    return 'Zoo' if ['zoo', 'zoology'].include?(subject.downcase)
    return 'Math' if ['maths', 'math', 'mathematics'].include?(subject.downcase)
    return subject
  end

  def get_subject_max_marks
    max_marks = {}
    data["subjects"].each do |sub_name, sub_data|
      if neet_new_pattern?
        max_marks[self.class.get_subject_code(sub_name)] = 180
      else
        from = sub_data['from'] + 1
        to = sub_data['from'] + sub_data['count']
        total_marks = 0
        from.upto(to) do |q_index|
          model_ans = answer_key[(q_index).to_s]
          total_marks += model_ans['pm']
        end
        max_marks[self.class.get_subject_code(sub_name)] = total_marks
      end
    end
    return max_marks
  end

  def neet_new_pattern?
    sub_data = self.data['subjects']
    return false unless sub_data.is_a?(Hash) && sub_data.size == 4

    sub_data.all? { |_, subject| subject["count"] == 50 }
  end

  def calculate_subject_scores
    return if self.omr_student_tests.blank?

    subject_toppers = {}
    self.omr_student_tests.each do |student_test|
      ans = student_test.student_ans.include?('|') ? student_test.student_ans.split("|") : student_test.student_ans
      subject_scores = {}

      test = student_test.child_test_id.present? ? Omr::Test.find(student_test.child_test_id) : self
      test.data['subjects'] ||= {'single_subject' => { 'from' => 0, 'count' => test.no_of_questions }}

      test.data['subjects'].each do |sub_name, sub_data|
        subject_toppers[sub_name] ||= 0

        from = sub_data['from'] + 1
        to = sub_data['from'] + sub_data['count']
        sub_correct, sub_wrong, sub_skip = 0, 0, 0
        sub_correct_score, sub_wrong_score = 0, 0

        counter = 1
        neet_b_counter = 0
        neet_b_skip_counter = 0

        from.upto(to) do |q_index|
          next if neet_new_pattern? && neet_b_counter >= 10

          model_ans = test.answer_key[(q_index).to_s]
          std_ans = ans[q_index - 1]

          if model_ans['ans'].include?("M")
            sub_correct += 1
            sub_correct_score += model_ans['pm']
            next
          end

          if std_ans == '@'
            sub_skip += 1
            if neet_new_pattern?
              counter += 1
              neet_b_skip_counter += 1 if counter > 35
            end
            next
          end

          if model_ans['is_num']
            numeric_ans = model_ans['ans'].first.to_f.round(2)
            std_ans = std_ans.to_f.round(2)
            is_correct = (numeric_ans == std_ans)
          else
            is_correct = model_ans['ans'].include?(std_ans)
          end

          if is_correct
            sub_correct += 1
            sub_correct_score += model_ans['pm']
          else
            sub_wrong += 1
            sub_wrong_score += model_ans['nm']
          end

          if neet_new_pattern?
            neet_b_counter += 1 if counter > 35 && std_ans != '@'
            counter += 1
          end
        end

        # binding.pry if student_test.omr_student_id == 3825 && student_test.omr_test_id == 314
        if neet_new_pattern? && neet_b_counter <= 10
          sub_skip = sub_skip - (neet_b_skip_counter - (10 - neet_b_counter))
        end

        subject_scores[sub_name] = {
          score: sub_correct_score - sub_wrong_score,
          correct_count: sub_correct,
          wrong_count: sub_wrong,
          skip_count: sub_skip,
          correct_score: sub_correct_score,
          wrong_score: sub_wrong_score
        }

        if (sub_correct_score - sub_wrong_score) > subject_toppers[sub_name]
          subject_toppers[sub_name] = sub_correct_score - sub_wrong_score
        end
      end

      student_test.update(data: subject_scores)
    end

    self.toppers['ALL'] = omr_student_tests.maximum(:score)
    self.toppers.merge!(subject_toppers)
    self.save
  end

  def get_ans_key_and_subjects(test)
    { ans_key: test.answer_key, subjects: test.data['subjects'] }
  end

  def sort_subjects
    return if self.data['subjects'].blank?

    self.data['subjects'] = self.data['subjects'].sort_by { |_, inner_hash| inner_hash["from"] }.to_h
    self.save
  end

  def single_subject?
    return true if self.data['subjects'].blank?
    self.data['subjects'].keys.size == 1 && self.data['subjects'].keys.first == 'single_subject'
  end
end
