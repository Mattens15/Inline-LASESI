OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['381156869034730'], ENV['af04d1e74eaca77242ad9b47edcf099d']
  provider :google_oauth2, '601967636918-rligj76d64b59lanmja8lgc50b7jma2a.apps.googleusercontent.com', 'JeiU7zFHm3QJXR18cRyfEgOI', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end

Rails.application.config.middleware.use OmniAuth::Builder do

end
