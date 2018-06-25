require 'rails_helper'

RSpec.describe Room, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  context "Creating a invalid room" do
  
    describe "When i put a blank name" do
      it "should not be valid" do
        room = @user.rooms.build(:name => '', :max_participants => 2, :time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i put a invalid name" do
      it "should not be valid" do
        room = @user.rooms.build(:name => '//aaa___----??', :max_participants => 2, :time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i put a looong name" do
      it "should not be valid" do
        room = @user.rooms.build(:name => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', :max_participants => 2, :time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i put a short name" do
      it "should not be valid" do
        room = @user.rooms.build(:name => 'a', :max_participants => 2, :time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i don't fill max_participants" do
      it "should not be valid" do
        room = @user.rooms.build(:name => 'Antoninino', :time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i fill max_participants with a value lower than 1" do
      it "should not be valid" do
        room = @user.rooms.build(:name => 'Antoninino', :max_participants => 0, :time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i don't fill time" do
      it "should not be valid" do
        room = @user.rooms.build(:name => 'Provarspec', :max_participants => 15);
        expect(room).not_to be_valid
      end
    end
  end
  
  context "Creating a valid room without a valid user" do
    describe "Filling all data correctly" do
      it "should not save" do
        room = Room.new(:name => 'Abaco', :max_participants => 1,:time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room.save).not_to be true
      end
    end
  end
  
  context "Creating a valid room with a valid user" do
    describe "Filling all data correctly" do
      it "should save" do
        room = @user.rooms.build(:name => 'Abaco', :max_participants => 1, :time_from => Time.now, :time_to => Time.now + 60*60)
        expect(room.save).to be true
      end
    end
  end
  
  describe "Creating a room without max unjoin time" do
    it "should fill it by itself" do
      room = @user.rooms.create!(attributes_for(:valid_room))
      expect(room.max_unjoin_time).not_to be nil
      expect(room.max_unjoin_time).to eq Time.at((Time.parse(room.time_from.to_s) - 1.hour).to_i)
    end
  end
end
