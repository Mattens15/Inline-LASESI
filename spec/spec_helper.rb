require 'capybara/rspec'
require 'database_cleaner'
ENV["RAILS_ENV"] ||= 'test'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.disable_monkey_patching!
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.include Capybara::DSL
end
