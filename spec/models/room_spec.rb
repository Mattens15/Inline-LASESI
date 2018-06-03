require 'rails_helper'

RSpec.describe Room, type: :model do
  context "Creating a invalid room" do
  
    describe "When i put a blank name" do
      it "should not save" do
        room = Room.new(:name => '', :max_participants => 2)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i put a invalid name" do
      it "should not save" do
        room = Room.new(:name => 'aaa___----??', :max_participants => 2)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i put a looong name" do
      it "should not be valid" do
        room = Room.new(:name => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', :max_participants => 2)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i put a short name" do
      it "should not be valid" do
        room = Room.new(:name => 'a', :max_participants => 2)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i don't fill max_participants" do
      it "should not be valid" do
        room = Room.new(:name => 'Antoninino')
        expect(room).not_to be_valid
      end
    end
    
    describe "When i fill max_participants with a value lower than 1" do
      it "should not be valid" do
        room = Room.new(:name => 'Antoninino', :max_participants => 0)
        expect(room).not_to be_valid
      end
    end
    
  end
  
  context "Creating a valid room without a valid user" do
    describe "Filling all data correctly" do
      it "should not save" do
        room = Room.new(:name => 'Abaco', :max_participants => 1)
        expect(room.save).not_to be true
      end
    end
  end
  
  context "Creating a valid room with a valid user" do
    describe "Filling all data correctly" do
      it "should save" do
        user = User.new(:username => 'Antonio', :email => 'danieligno10@gmail.com', :password => '12341234', :password_confirmation => '12341234')
        expect(user.save).to be true
        room = user.rooms.build(:name => 'Abaco', :max_participants => 1, :time_from => '2018-06-19 19:10', :time_to => '2018-06-19 22:10')
        expect(room.save).to be true
      end
    end
  end
  
  context "Trying to add another room host" do
    describe "as non-owner" do
      it "should not add another room host" do
        owner = User.new(:username => 'Antonio', :email => 'danieligno10@gmail.com', :password => '12341234', :password_confirmation => '12341234')
        user = User.new(:username => 'Marco', :email => 'marco@gmail.com', :password => '12341234', :password_confirmation => '12341234')
        
        expect(owner.save).to be true
        expect(user.save).to be true
        
        room = user.rooms.build(:name => 'Abaco', :max_participants => 1, :time_from => '2018-06-19 19:10', :time_to => '2018-06-19 22:10')
        expect(room.save).to be true
        
        
        expect(room.add_room_host(owner)).not_to be_valid
      end
    end
  end
  
end
