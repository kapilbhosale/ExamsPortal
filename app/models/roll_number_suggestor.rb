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
    "repeater" => 10_000,
    "test_series" => 1200,
    "crash_course" => 90_000,
    "7th" => 1_000,
    "8th" => 2_000,
    "9th" => 3_000,
    "10th" => 4_000
  }
  def self.suggest_roll_number(batch_name)
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
