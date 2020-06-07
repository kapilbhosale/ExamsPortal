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

  def self.total_fees_by_name
    {
      phy: 25_000,
      chem: 25_000,
      bio: 25_000,
      pdb: 60_000,
      pc: 50_000,
    }
  end
end
