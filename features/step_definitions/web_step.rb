# Note: This is not the old cucumber-rails web_steps.rb
#       It is a subset of the useful steps that aren't terrible

require 'uri'

#GIVEN

Given /^(?:I )am a registered user$/ do
  @user = User.create!(:username => 'Topo gigio', :email => "example@mail.com", :password => '12345678', :password_confirmation => '12345678')
end

And /^(?:I )log in$/ do
  visit @localhost_url+"login"
  fill_in "session_email", :with => @user.email
  fill_in "session_password", :with => @user.password
  click_button('Log in')
end

#WHEN 
When /^(?:I )create a room$/ do
  @room = @user.rooms.create!(:name => 'Room prova1', 
                              :time_from => '2018-06-08 12:00', 
                              :time_to => '2018-06-08 14:00', 
                              :max_participants => 5,
                              :latitude => 41.908339,
                              :longitude => 12.479098,
                              :address => 'via delBabuino, 00187 Roma Roma, Italy')
end

When /^I visit (.*)$/ do |page_name|
  if(page_name == 'dashboard')
		visit @localhost_url+"#{page_name}/#16/41.908339/12.479098"
	else
		 visit @localhost_url+"/#{page_name}"
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

Then /^I should see calendar$/ do	
  expect(page.find('#inputdateFrom', :visible => false)).not_to be nil
  expect(page.find('#inputdateTo', :visible => false)).not_to be nil
end

Then /^I can choose a date and time$/ do
  within ".row" do
    click_on "input"
  end
end
