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
      it "should not save" do
        room = Room.new(:name => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', :max_participants => 2)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i put a short name" do
      it "should not save" do
        room = Room.new(:name => 'a', :max_participants => 2)
        expect(room).not_to be_valid
      end
    end
    
    describe "When i don't fill max_participants" do
      it "should not save" do
        room = Room.new(:name => 'Antoninino')
        expect(room).not_to be_valid
      end
    end
    
    describe "When i fill max_participants with a value lower than 1" do
      it "should not save" do
        room = Room.new(:name => 'Antoninino', :max_participants => 0)
        expect(room).not_to be_valid
      end
    end
    
  end
  
  context "Creating a valid room" do
    describe "Filling all data correctly" do
      it "should save" do
      room = Room.new(:name => 'Abaco', :max_participants => 1)
      expect(room).not_to be_valid
      end
    end
  end
  
end
