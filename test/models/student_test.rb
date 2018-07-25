# == Schema Information
#
# Table name: students
#
#  id             :bigint(8)        not null, primary key
#  roll_number    :integer          not null
#  name           :string           not null
#  mother_name    :string
#  date_of_birth  :date
#  gender         :integer          default(0)
#  ssc_marks      :float
#  student_mobile :string(20)
#  parent_mobile  :string(20)       not null
#  address        :text
#  college        :string
#  photo          :string
#  category_id    :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
