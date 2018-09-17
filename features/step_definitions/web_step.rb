# Note: This is not the old cucumber-rails web_steps.rb
#       It is a subset of the useful steps that aren't terrible

require 'uri'

#GIVEN

Given /^(?:I )am a registered user$/ do
  @user = User.create!(:username => 'Topo gigio', :email => "example@mail.com", :password => '12345678', :password_confirmation => '12345678')
end

Given /^(?:I )am an admin$/ do
  @user = User.create!(:username => 'Topo gigio', :email => "example@mail.com", :password => '12345678', :password_confirmation => '12345678',:admin=>true)
end

And /^a room already exists/ do
  @owner = User.create!(:username => 'Owner', :email => "owner@mail.com", :password => '12345678', :password_confirmation => '12345678')
  @room = @owner.rooms.create!(:name => 'Room prova1', 
                              :max_participants => 5,
                              :time_from  => Time.now + 60*60*12,
                              :time_to    => Time.now + 60*70*24,
                              :latitude   => 41.908339,
                              :longitude  => 12.479098,
                              :address    => 'via delBabuino, 00187 Roma Roma, Italy',
                              :fifo       => true)
end

And /^a private room already exists/ do
  @owner = User.create!(:username => 'Owner', :email => "owner@mail.com", :password => '12345678', :password_confirmation => '12345678')
  @room = @owner.rooms.create!(:name => 'Room prova1', 
                              :max_participants => 5,
                              :time_from  => Time.now + 60*60*12,
                              :time_to    => Time.now + 60*70*24,
                              :latitude   => 41.908339,
                              :longitude  => 12.479098,
                              :private    => true,
                              :address    => 'via delBabuino, 00187 Roma Roma, Italy',
                              :fifo       => true)
end

And /^a conversation with (.+) exists/ do |name|
  @user.send_message(User.find_by(username: name),'test','test')
end

And /^user (.+) exists/ do |name|
  @user2 = User.create!(:username => name, :email => 'aoaoao@gmail.com', :password => '12341234', :password_confirmation => '12341234')
end


And /^(?:I )log in$/ do
  visit @test_url+"login"
  fill_in "session_email", :with => @user.email
  fill_in "session_password", :with => @user.password
  page.find('#session_submit').click
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
  if page_name == 'room edit'
    room = Room.take
    visit @test_url+"rooms/#{room.id}/edit"
  elsif page_name == 'my profile'
    page.find('.navicon2').click
  else
    visit @test_url+"#{page_name}"
  end
end

When /^(.+) sends me a direct/ do|user|
  u=User.find_by(username: user)
  u.reply_to_conversation(u.mailbox.conversations.last,"risposta")
end
When /^I send (.+) a direct/ do|user2|
  u=User.find_by(username: user2)
  @user.reply_to_conversation(@user.mailbox.conversations.last,"risposta")
end


And /^I fill (.*) with (.*)/ do |element, value|
	fill_in element, :with => value
end

And /^I am alreay reserved/ do
  expect(@user.reservations.create!(room_id: @room.id)).not_to be nil
end

And /^I pick the first one/ do
  find('li.active').click
end

And /^I click (.*)/ do |element|
  click_on(element,match: :first)
end

And /^I select the recurrence/ do
  page.find(:xpath,"//*[text()='Ricorrenza evento:']").click
  page.find(:xpath,"//*[text()='Set schedule...']").click
  expect(page.find('.rs_dialog_holder')).not_to be nil
  click_on('OK')
end

And /^I select TimeFrom/ do
  within('#time_from_div') do
    find('.flatpickr-input').click
  end
  within('div.flatpickr-calendar') do
    within('div.flatpickr-innerContainer') do
      within('div.flatpickr-days') do
        within('div.dayContainer') do
          find('.today').click      
        end
      end
    end
  end
end

And /^I select TimeTo/ do
  within('#time_to_div') do
    find('.flatpickr-input').click
  end
  within('div.flatpickr-calendar') do
    within('div.flatpickr-innerContainer') do
      within('div.flatpickr-days') do
        within('div.dayContainer') do
          find('.today').click      
        end
      end
    end
  end
end

And /^I attach a file/ do
  page.attach_file('room[avatar]', "#{Rails.root}/public/testing_avatar.png")
end

#THEN 

Then /^I should see marker$/ do	
  expect(page.find('#map')).not_to be nil
  expect(page.find('#marker-0', visible: 'false')).not_to be nil
end

Then /^room has coordinates/ do
  room = Room.first
  expect(room.latitude).not_to be nil
  expect(room.longitude).not_to be nil
  expect(room.address).not_to be nil
end

Then /^I should be reserved/ do
  sleep 2
  room = Room.take
  expect(room.reservations.exists?(user_id: @user.id)).to be true
end

Then /^I should not be reserved/ do
  room = Room.take
  expect(room.reservations.exists?(user_id: @user.id)).to be false
end

Then /^(.+) should be room host/ do |username|
  user = User.find_by(username: username)
  room = Room.take
  expect(user).not_to be nil
  expect(Power.exists?(user_id: user.id, room_id: room.id))
end

Then /^(.+) should receive a new direct/ do |username|
  if username.eql?('I')
    user=@user
  else
    user=User.find_by(username: username)
  end
  expect(user.mailbox.inbox.last.count_messages).to be > 0
end
Then /^Room should have avatar/ do
  room = Room.take
  expect(room.avatar).not_to be nil
end

Then /^Room should not have avatar/ do
  room = Room.take
  expect(room.avatar.url).to eq('//placehold.it/200')
end

Then /^I should see 404/ do
  element = page.find('.error-code')
  expect(element).not_to be nil
  expect(element.text).to eq('404')
end

Then /^I should see how many rooms I have attended/ do
  puts(@user.rooms_attended)
  puts(page.find(:xpath,"//*[@id='rooms-attended']").value)
  #expect(@user.rooms_attended).to be eq(page.find(:xpath,"//*[@id='rooms-attended']").value.to_i)
end
Then /^Room should have multiple instances/ do
  expect(Room.all.count).to be > 1
end

Then /^I should be on room page/ do
  expect(page).to have_text("Room was successfully created.")
end

Then /^I should see a new message/ do
  expect(@room.messages.count).to be > 0
end

Then /^the website should be suspended/ do
  expect($should_be_offline).to be true
end

Then /^the website should be restored/ do
  expect($should_be_offline).to be false
end

Then /^I should see room name/ do
  
  within('.start-date') do
    room = Room.take
    expect(page).to have_text("#{room.name}", maximum: 2)
  end
end
