# == Schema Information
#
# Table name: roll_number_suggestors
#
#  id                :bigint(8)        not null, primary key
#  batch_name        :string
#  criteria          :string
#  initial_suggested :integer
#  last_suggested    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class RollNumberSuggestor < ApplicationRecord

  INITIAL_VALS = {
    "11th" => 40_000,
    "12th" => 60_000,
    "test_series" => 1200,
    "crash_course" => 90_000,
    "7th" => 1_000,
    "8th" => 2_000,
    "9th" => 3_000,
    "10th" => 4_000,
    'free' => 1_00_000,
    'pay_adm' => 1000,
    '11th_new' => 2_00_000,
    '11th_22_23' => 40_000,
    "12th_22_23" => 60_000,
    'set_aurangabad' => 1_000,
    '11_aurangabad' => 20_000,
    'set-aur' => 5_000,
    'repeater_22_23' => 10_000,
    'neet_23_24' => 50_000,
    'test_series' => 1_000_000,
    'neet_saarthi_new' => 1_00_000,
    'rep_set_25_26_new' => 5100001
  }

  def self.suggest_roll_number(batch_name, na=nil)
    batch_name = '12th_22_23' if batch_name == '12th'
    batch_name = "rep_set_25_26_new" if batch_name == '11th_set'

    return Student.random_roll_number if batch_name == 'test-series'
    return Student.random_roll_number if batch_name == '12th_set'
    return Student.random_roll_number if batch_name == 'repeater'
    return Student.random_roll_number if batch_name == '12th'
    return Student.random_roll_number if batch_name == '11th_new'

    batch_name = '11th_set_2025' if batch_name == 'neet_saarthi'

    rns = self.find_by(batch_name: batch_name)

    if rns.blank?
      rns = self.create({
        batch_name: batch_name,
        initial_suggested: default_rn(batch_name)
      })
    end

    if rns.last_suggested.present?
      rns.last_suggested += 1
    else
      rns.last_suggested = rns.initial_suggested || default_rn(batch_name)
    end
    rns.save
    return rns.last_suggested
  end

  def self.default_rn(batch_name)
    INITIAL_VALS[batch_name] || 50_000
  end
end
