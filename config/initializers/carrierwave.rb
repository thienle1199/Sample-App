CarrierWave.configure do |config|
  config.dropbox_access_token = Rails.application.secrets.dropbox_access_token
end