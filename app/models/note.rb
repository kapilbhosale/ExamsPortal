# == Schema Information
#
# Table name: notes
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  min_pay     :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  org_id      :bigint(8)
#
# Indexes
#
#  index_notes_on_org_id  (org_id)
#

class Note < ApplicationRecord
  belongs_to :org

  enum min_pay: {
    '100 percent': '100_percent',
    '90 percent': '90 percent',
    '80 percent': '80 percent',
    '75 percent': '75 percent',
    '50 percent': '50 percent',
    '40 percent': '40 percent',
    '10 percent': '10 percent',
    '0 percent': '0 percent'
   }
end
