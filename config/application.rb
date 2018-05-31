require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Inline
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil
    
    config.generators do |g|
			g.test_framework :rspec,
		    :fixtures => true,
		    :view_specs => false,
		    :helper_specs => false,
		    :routing_specs => false,
		    :controller_specs => true,
		    :request_specs => true
			g.fixture_replacement :factory_girl, :dir => "spec/factories"
		end
    
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag
    }
    
    #INIZIALIZZAZIONE CALENDAR
    Inline::Application.configure do
      require 'google/apis/calendar_v3'
      require 'google/api_client/auth/key_utils'
      
      keypath = Rails.root.join('config','key.p12').to_s
      key = Google::APIClient::KeyUtils::load_from_pkcs12(keypath, 'notasecret')
    
      client_options = {
        :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
        :audience             => 'https://accounts.google.com/o/oauth2/token',
        :scope                => 'https://www.googleapis.com/auth/calendar',
        :issuer               => 'inline@inline-205713.iam.gserviceaccount.com',
        :sub                  => 'inline@inline-205713.iam.gserviceaccount.com',
        :signing_key          => key      
      }
      
      cal = Google::Apis::CalendarV3::CalendarService.new
      cal.authorization = Signet::OAuth2::Client.new(client_options).tap{ |auth| auth.fetch_access_token! }
      
      config.cal = cal
      #USATO PER CONDIVIDERE IL CALENDARIO
      #rule = Google::Apis::CalendarV3::AclRule.new(
      #  scope: {
      #    type: 'user',
      #    value: 'danieligno10@gmail.com'
      #  },
      #  role: 'owner'  
      #)
      #cal.insert_acl('primary', rule)
    end
  end
end

