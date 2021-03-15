unless Rails.env.development? || Rails.env.test?
CarrierWave.configure do |config|
  CarrierWave.configure do |config|
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ['S3_ACCESS_KEY'],
      aws_secret_access_key: ['S3_SECRET_KEY'],
      region: ['S3_REGION']
    }

    config.fog_directory  = ['S3_BUCKET']
    config.cache_storage = :fog
  end
end
