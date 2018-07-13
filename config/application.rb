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
    $should_be_offline=false
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
    
    puts '=>Starting calendar'
    #INIZIALIZZAZIONE CALENDAR
    Inline::Application.configure do
      require 'googleauth'
      require 'google/apis/calendar_v3'
      require 'google/api_client/client_secrets'
      keypath = Rails.root.join('config','key.json')
  
      scope = ['https://www.googleapis.com/auth/calendar']
      authorization =  Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: keypath,
        scope: scope
      )

      # Clone and set the subject
      auth_client = authorization.dup
      auth_client.sub = 'inline@inline-205713.iam.gserviceaccount.com'
      auth_client.fetch_access_token!

      # Initialize the API
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = auth_client
      
      rule = Google::Apis::CalendarV3::AclRule.new(
        scope: {
          type: 'user',
          value: 'danieligno10@gmail.com'
        },
        role: 'owner'  
      )
      #service.insert_acl('inline@inline-205713.iam.gserviceaccount.com', rule)

      config.cal = service
      #RESET CALENDAR
      #puts 'Reset eventi in corso...'
      #calendar_list = service.list_events('inline@inline-205713.iam.gserviceaccount.com', single_events: true)
      #calendar_list.items.each do |e|
      #  service.delete_event('inline@inline-205713.iam.gserviceaccount.com', e.id)
      #  puts "Eliminato #{e.id}"
      #end
    end
  
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end

