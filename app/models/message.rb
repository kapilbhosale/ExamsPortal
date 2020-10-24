# == Schema Information
#
# Table name: messages
#
#  id               :bigint(8)        not null, primary key
#  message          :text
#  messageable_type :string
#  sender_name      :string
#  sender_type      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  messageable_id   :bigint(8)
#  sender_id        :bigint(8)
#
# Indexes
#
#  index_messages_on_messageable_type_and_messageable_id  (messageable_type,messageable_id)
#

class Message < ApplicationRecord
  belongs_to :messageable, polymorphic: true

  def sender
    if sender_type == 'Student'
      Student.find_by(id: sender_id)
    else
      Admin.find_by(id: sender_id)
    end
  end
end
