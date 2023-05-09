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
    'rcc_rep_set_21_22' => 1_000,
    'pay_adm' => 1000,
    '11th_new' => 2_00_000,
    '11th_set' => 1_000,
    'neet_saarthi' => 1_00_001,
    '12th_set' => 1_000,
    '11th_22_23' => 40_000,
    "12th_22_23" => 60_000,
    'set_aurangabad' => 1_000,
    '11_aurangabad' => 20_000,
    'set-aur' => 5_000,
    'repeater_set' => 2_000,
    'repeater_22_23' => 10_000,
    '11th_set_3' => 50_000,
    'neet_23_24' => 50_000,
    'rep_set_23_24' => 10_000,
  }

  def self.suggest_roll_number(batch_name, na=nil)
    if na&.free? && batch_name != 'neet_saarthi' && batch_name != '12th_set' && batch_name != '11th_set' && batch_name != '12th_set_1'
      batch_name = '11th_set_22_23'
    end

    batch_name = '12th_22_23' if batch_name == '12th'

    if batch_name == '11th_new'
      batch_name = na.rcc_branch == 'aurangabad' ? '11_aurangabad' : '11th_22_23'
    end

    batch_name = "rep_set_23_24" if na&.free? && batch_name == '12th_set'
    batch_name = "11th_set_3" if na&.free? && batch_name == '11th_set'
    batch_name = 'repeater_22_23' if batch_name == 'repeater'

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
