# Note: This is not the old cucumber-rails web_steps.rb
#       It is a subset of the useful steps that aren't terrible

require 'uri'

#GIVEN

Given /^(?:I )am a registered user$/ do
  @user = User.create!(:username => 'Topo gigio', :email => "example@mail.com", :password => '12345678', :password_confirmation => '12345678')
end

And /^(?:I )log in$/ do
  @user.authenticate(:email => 'example@mail.com', :password => '12345678')
end

#WHEN 
When /^(?:I )create a room$/ do
  @room = @user.rooms.create!(:name => 'Room prova1', 
                              :time_from => '2018-06-08 12:00', 
                              :time_to => '2018-06-09 12:00', 
                              :max_participants => 5,
                              :latitude => 41.908339,
                              :longitude => 12.479098,
                              :address => 'via delBabuino, 00187 Roma Roma, Italy')
end

When /^I visit (.*)$/ do |page_name|
  @port = Capybara.current_session.server.port
  Capybara.default_max_wait_time = 10
  if(page_name == 'dashboard')
		visit "http://127.0.0.1:#{@port}/#{page_name}/#16/41.908339/12.479098"
	else
		 visit "http://127.0.0.1:#{@port}/#{page_name}"
	end
end

And /^I fill (.*)/ do |element|
	fill_in 'radius', :with => 5
end
 
And /^I search a location$/ do
	visit "http://127.0.0.1:#{@port}/#9.21/41.876/12.5324"
end

#THEN 

Then /^I should see marker$/ do	
  expect(page.find('#map')).not_to be nil
  expect(page.find('#marker-0')).not_to be nil
end
