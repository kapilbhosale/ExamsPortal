# frozen_string_literal: true

if true || Rails.env.production?
  CarrierWave.configure do |config|
    config.storage    = :aws
    config.aws_bucket = 'smart-exams-production'
    config.aws_acl    = 'public-read'
    config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7
    config.aws_credentials = {
      access_key_id:     ENV.fetch('AWS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET'),
      region:            'ap-south-1'
    }
  end
else
  config.storage = :file
  config.enable_processing = Rails.env.development?
end
