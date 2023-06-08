# == Schema Information
#
# Table name: photo_upload_logs
#
#  id                     :bigint(8)        not null, primary key
#  filename               :string
#  not_found_count        :integer
#  not_found_roll_numbers :jsonb
#  success_count          :integer
#  sucess_roll_numbers    :jsonb
#  uploaded_by            :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class PhotoUploadLog < ApplicationRecord
end
