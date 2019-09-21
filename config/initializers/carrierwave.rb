CarrierWave.configure do |config|

    if Rails.env.production?
        config.storage :fog
        config.fog_provider = 'fog/aws'
        config.fog_credentials = {
            provider: 'AWS',
            aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
            aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
            region: ENV['AWS_REGION'],
            path_style: true
        }
        config.fog_directory = ENV['AWS_S3_BUCKET']
        config.asset_host = ENV['HOST_NAME']
    else
        config.storage :file
        config.asset_host = ENV['HOST_NAME']
    end
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/