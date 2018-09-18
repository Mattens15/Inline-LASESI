require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'factory_bot_rails'
require 'rspec/rails'
require "capybara/rspec"
require 'database_cleaner'

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.fixture_path = "#{::Rails.root}/spec/factories"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  
  
  config.before(:each) do
    #puts 'Rollback transaction...'
    DatabaseCleaner.strategy = :transaction
  end
  
  config.before(:each, js: true) do
    #puts 'Rollback transaction...'
    DatabaseCleaner.strategy = :truncation
  end
  
  config.before(:each) do
    #puts 'DatabaseCleaner starting...'
    DatabaseCleaner.start
  end
  
  config.after(:each) do
    #puts 'DatabaseCleaner cleaning...'
    DatabaseCleaner.clean
    DatabaseCleaner.clean_with(:truncation)
  end
end
