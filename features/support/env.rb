require 'capybara'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'selenium-webdriver'
 
 
#pass environment variables to control which browser is used for testing. Default is HEADLESS/POLTERGEIST
#usage: firefox=true bundle exec cucumber features/test.feature
 
 
if ENV['chrome']
 Capybara.default_driver = :chrome
 Capybara.register_driver :chrome do |app|
 options = {
 :js_errors => false,
 :timeout => 360,
 :debug => false,
 :inspector => false,
 }
 Capybara::Selenium::Driver.new(app, :browser => :chrome)
 end
elsif ENV['firefox']
 Capybara.default_driver = :firefox
 Capybara.register_driver :firefox do |app|
 options = {
 :js_errors => true,
 :timeout => 360,
 :debug => false,
 :inspector => false,
 }
 Capybara::Selenium::Driver.new(app, :browser => :firefox)
 end
elsif ENV['safari']
 Capybara.default_driver = :safari
 Capybara.register_driver :safari do |app|
 options = {
 :js_errors => false,
 :timeout => 360,
 :debug => false,
 :inspector => false,
 }
 Capybara::Selenium::Driver.new(app, :browser => :safari)
 end
elsif ENV['opera']
 Capybara.default_driver = :opera
 Capybara.register_driver :opera do |app|
 options = {
 :js_errors => false,
 :timeout => 360,
 :debug => false,
 :inspector => false,
 }
 Capybara::Selenium::Driver.new(app, :browser => :opera)
 end
elsif
Capybara.default_driver = :poltergeist
 Capybara.register_driver :poltergeist do |app|
 options = {
 :js_errors => false,
 :timeout => 360,
 :debug => false,
 :phantomjs_options => ['--load-images=no', '--disk-cache=false'],
 :inspector => false,
 }
 Capybara::Poltergeist::Driver.new(app, options)
 end
end
