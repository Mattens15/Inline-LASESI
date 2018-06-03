OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['381156869034730'], ENV['af04d1e74eaca77242ad9b47edcf099d']
end
