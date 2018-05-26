# Note: This is not the old cucumber-rails web_steps.rb
#       It is a subset of the useful steps that aren't terrible

require 'uri'


Given /^(?:I )am a registered user$/ do
  User.create!({:id => 1, :email => "example@mail.com", :password => '123456'})
end

And /^(?:I )log in$/do
  pending "not implemented yet"
end

When /^I visit the map page$/ do
  visit map_path
end

And /^(?:|I )search a location$/ do |element|
  pending "not implemented yet"
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
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
