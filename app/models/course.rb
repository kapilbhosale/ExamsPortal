# == Schema Information
#
# Table name: courses
#
#  id          :bigint(8)        not null, primary key
#  description :text
#  fees        :decimal(, )      default(0.0)
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Course < ApplicationRecord
end
