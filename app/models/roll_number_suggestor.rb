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
    '11th_set_24_' => 1_000_000,
    '11th_set_24_latur' => 10_10_000,
    '11th_set_24_nanded' => 10_30_000,
    '11th_set_24_beed' => 10_50_000,
    '11th_set_24_parbhani' => 10_60_000,
    '11th_set_24_hingoli' => 10_70_000,
    '11th_set_24_yavatmal' => 10_80_000,
    '11th_set_24_solapur' => 10_90_000,
    '11th_set_24_kolhapur' => 11_00_000,
    '11th_set_24_buldhana' => 11_10_000,
    '11th_set_24_jalna' => 11_20_000,
    '11th_set_24_pune' => 11_30_000,
    '11th_set_24_pimpri' => 11_40_000,
    '11th_set_24_akola' => 11_50_000,
    '11th_set_24_sambhaji_nagar' => 11_60_000,
    '11th_set_24_jalgaon' => 11_70_000,
    '11th_set_24_nashik' => 11_80_000,
    '11th_set_24_satara' => 11_90_000,
    '11th_set_24_ahmadnagar' => 12_00_000,
    '11th_set_24_amravati' => 12_10_000,
    '11th_set_24_nagpur' => 12_20_000,
    '11th_set_24_washim' => 12_30_000,
    '11th_set_24_dharashiv' => 12_40_000,
    '11th_set_24_mumbai' => 12_50_000,
    'neet_saarthi_24_25' => 1_00_001
  }

  def self.suggest_roll_number(batch_name, na=nil)
    batch_name = '12th_22_23' if batch_name == '12th'

    batch_name = 'repeater_22_23' if batch_name == 'repeater'
    batch_name = "11th_set_24_#{na.extra_data['set_center_11th']}" if batch_name == '11th_set'

    return Student.random_roll_number if batch_name == 'test-series'
    return Student.random_roll_number if batch_name == '12th_set'
    batch_name = 'neet_saarthi_24_25' if batch_name == 'neet_saarthi'

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
