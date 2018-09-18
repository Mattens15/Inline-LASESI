require 'database_cleaner'

RSpec.configure do |config|

  puts 'Database cleaner configuring loading...'

  begin
    DatabaseCleaner.strategy = :transaction
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end

end
