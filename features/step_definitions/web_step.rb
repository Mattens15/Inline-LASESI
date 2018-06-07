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
                              :longitutde => 12.479098
                              :address => 'via delBabuino, 00187 Roma Roma, Italy")
end

When /^I visit (.+)$/ do |page_name|
  visit "/#{page_name}"
end


And /^(?:|I )search a location$/ do |element|
  visit "/#16/41.908339/12.479098'"
end


#THEN 

Then /^(?:|I )should be on (.+) $/ do |page_name|
  current_path = URI.parse(current_url).select(:path, :query).compact.join('?')
  if defined?(Spec::Rails::Matchers)
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I ) should see (.+)$/ do |element|
  pending "not implemented yet"
end
