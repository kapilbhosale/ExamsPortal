# == Schema Information
#
# Table name: new_admissions
#
#  id                   :bigint(8)        not null, primary key
#  address              :text
#  city                 :string
#  district             :string
#  email                :string
#  first_name           :string
#  gender               :integer          default(NULL)
#  last_exam_percentage :string
#  last_name            :string
#  middle_name          :string
#  parent_mobile        :string           not null
#  payment_status       :integer          default("initial")
#  school_name          :string
#  student_mobile       :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_id            :integer
#  payment_id           :string
#

class NewAdmission < ApplicationRecord
  enum payment_status: {
    initial: 0,
    initiated: 1,
    in_progress: 2,
    success: 3,
    failure: 4
  }

  enum gender: { male: 1, female: 2, other: 3 }
  enum course: { physics: 1, chemistry: 2, biology: 3, pcb: 4 }

  after_create :create_unique_payment_id

  private

  def create_unique_payment_id
    self.payment_id = SecureRandom.uuid
    save
  end
end
