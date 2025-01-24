# == Schema Information
#
# Table name: omr_tests
#
#  id               :bigint(8)        not null, primary key
#  answer_key       :jsonb
#  branch           :string
#  data             :jsonb
#  db_modified_date :string
#  deleted_at       :datetime
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
#  index_omr_tests_on_deleted_at  (deleted_at)
#  index_omr_tests_on_org_id      (org_id)
#
# Foreign Keys
#
#  fk_rails_...  (org_id => orgs.id)
#

class Omr::Test < ApplicationRecord
  acts_as_paranoid

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

  def subjects
    if self.child_tests.present?
      return self.child_tests.first.data['subjects']
    else
      return self.data['subjects']
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
    if subjects.blank?
      total_marks = 0
      answer_key.each do |q_index, model_ans|
        total_marks += model_ans['pm']
      end
      max_marks['single_subject'] = total_marks
    else
      subjects.each do |sub_name, sub_data|
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
    end
    return max_marks
  end

  # need to consider as this method is not returning proper data is parent test i.e. booklet
  def neet_new_pattern?
    sub_data = subjects
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
        if neet_new_pattern?
          sub_scores = neet_calculations(sub_name, sub_data, ans, test, student_test)
        else
          sub_scores = non_neet_calculations(sub_data, ans, test, student_test)
        end

        subject_scores[sub_name] = sub_scores
        subject_toppers[sub_name] = sub_scores[:score] if sub_scores[:score] > subject_toppers[sub_name]
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
    return true if subjects.blank?
    subjects.keys.size == 1
  end


  def non_neet_calculations(sub_data, ans, test, student_test)
    from = sub_data['from'] + 1
    to = sub_data['from'] + sub_data['count']
    sub_correct, sub_wrong, sub_skip = 0, 0, 0
    sub_correct_score, sub_wrong_score = 0, 0

    from.upto(to) do |q_index|
      model_ans = test.answer_key[(q_index).to_s]
      std_ans = ans[q_index - 1]

      if model_ans['ans'].include?("M")
        sub_correct += 1
        sub_correct_score += model_ans['pm']
        next
      end

      if std_ans == '@'
        sub_skip += 1
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
    end

    return {
      score: sub_correct_score - sub_wrong_score,
      correct_count: sub_correct,
      wrong_count: sub_wrong,
      skip_count: sub_skip,
      correct_score: sub_correct_score,
      wrong_score: sub_wrong_score
    }
  end

  def neet_calculations(sub_name, sub_data, ans, test, student_test)
    from = sub_data['from'] + 1
    to = sub_data['from'] + sub_data['count']
    sub_correct, sub_wrong, sub_skip = 0, 0, 0
    neet_correct, neet_wrong, neet_skip = 0, 0, 0
    sub_correct_score, sub_wrong_score = 0, 0
    neet_correct_score, neet_wrong_score = 0, 0
    counter = 0


    from.upto(to) do |q_index|
      counter += 1
      break if neet_correct + neet_wrong >= 10

      model_ans = test.answer_key[(q_index).to_s]
      std_ans = ans[q_index - 1]

      if model_ans['ans'].include?("M")
        if counter <= 35
          sub_correct += 1
          sub_correct_score += model_ans['pm']
        else
          neet_correct += 1
          neet_correct_score += model_ans['pm']
        end
        next
      end

      if std_ans == '@'
        counter <= 35 ? sub_skip += 1 : neet_skip += 1
        next
      end

      if model_ans['ans'].include?(std_ans)
        if counter <= 35
          sub_correct += 1
          sub_correct_score += model_ans['pm']
        else
          neet_correct += 1
          neet_correct_score += model_ans['pm']
        end
      else
        if counter <= 35
          sub_wrong += 1
          sub_wrong_score += model_ans['nm']
        else
          neet_wrong += 1
          neet_wrong_score += model_ans['nm']
        end
      end
    end

    if neet_correct + neet_wrong >= 10
      adjusted_neet_skip = 0
    else
      adjusted_neet_skip = 10 - (neet_correct + neet_wrong)
    end

    return {
      score: sub_correct_score + neet_correct_score - (sub_wrong_score + neet_wrong_score),
      correct_count: sub_correct + neet_correct,
      wrong_count: sub_wrong + neet_wrong,
      skip_count: sub_skip + adjusted_neet_skip,
      correct_score: sub_correct_score + neet_correct_score,
      wrong_score: sub_wrong_score + neet_wrong_score
    }
  end
end
