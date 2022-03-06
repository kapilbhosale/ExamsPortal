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

  def self.get_course(courses)
    return Course.find_or_create_by(name: courses[0]) if courses.length == 1

    return Course.find_by(name: 'pcb') if courses.include?('pcb')

    return Course.find_by(name: courses.first) if courses.length == 1
    return Course.find_by(name: 'pcb') if courses.length == 3
    return Course.find_by(name: 'pcb') if courses.length == 4

    return Course.find_by(name: 'pc') if courses.include?('phy') && courses.include?('chem')
    return Course.find_by(name: 'pb') if courses.include?('phy') && courses.include?('bio')
    return Course.find_by(name: 'cb') if courses.include?('chem') && courses.include?('bio')

    Course.find_by(name: 'pcb')
  end
end
