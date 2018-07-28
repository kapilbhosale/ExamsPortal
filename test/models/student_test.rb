# == Schema Information
#
# Table name: students
#
#  id                     :bigint(8)        not null, primary key
#  address                :text
#  college                :string
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  date_of_birth          :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  gender                 :integer          default(0)
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  mother_name            :string
#  name                   :string           not null
#  parent_mobile          :string(20)       not null
#  photo                  :string
#  raw_password           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roll_number            :integer          not null
#  sign_in_count          :integer          default(0), not null
#  ssc_marks              :float
#  student_mobile         :string(20)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  category_id            :bigint(8)
#
# Indexes
#
#  index_students_on_category_id    (category_id)
#  index_students_on_name           (name)
#  index_students_on_parent_mobile  (parent_mobile)
#

require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
