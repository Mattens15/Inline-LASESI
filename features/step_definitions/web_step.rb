require 'uri'

#GIVEN

Given /^(?:I )am a unregistered user$/ do
    @user = User.create!(:username => 'mario', :email => "mario.rossi@gmail.com", :password => '12345678', :password_confirmation => '12345678')
end

And /^user (.+) exists/ do |name|
    @user2 = User.create!(:username => name, :email => 'aoaoao@gmail.com', :password => '12341234', :password_confirmation => '12341234')
end

And /^user (.+) exists/ do |email|
    @user3 = User.create!(:username => mario, :email => email, :password => '12341234', :password_confirmation => '12341234')
end

And /^(?:I )log in$/ do
    visit @test_url+"login"
    fill_in "session_email", :with => @user.email
    fill_in "session_password", :with => @user.password
    page.find('#session_submit').click
end