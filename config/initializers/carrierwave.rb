# frozen_string_literal: true

if Rails.env.production?
  CarrierWave.configure do |config|
    # config.storage    = :aws
    # config.aws_bucket = 'smart-exams-production'
    # config.aws_acl    = 'public-read'
    # config.aws_authenticated_url_expiration = 60 * 60 * 24 * 7
    # config.aws_credentials = {
    #   access_key_id:     ENV.fetch('AWS_KEY_ID'),
    #   secret_access_key: ENV.fetch('AWS_SECRET'),
    #   region:            'ap-south-1'
    # }

    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET'),
      region: 'ap-south-1'
    }
    config.fog_directory = 'aws-se-test-bucket'
    config.storage = :fog
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
