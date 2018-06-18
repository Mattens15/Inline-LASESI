require 'rails_helper'

RSpec.describe Power, type: :model do
  before(:each) do
    @owner  = FactoryBot.create(:owner)
    @user   = FactoryBot.create(:user)
    @room   = @owner.rooms.create(attributes_for(:valid_room))
  end

  after(:each) do
    @owner.destroy!
    @user.destroy!
    @room.destroy!
  end

  context "New powers" do
    describe "with all params" do
      it "should be fine" do
        power = Power.new(user_id: @user.id, room_id: @room.id)
        expect(power).to be_valid
      end
    end

    describe "without user" do
      it "should not be fine" do
        power = Power.new(room_id: @room.id)
        expect(power).not_to be_valid
      end
    end
    
    describe "without room" do
      it "should not be fine" do
        power = Power.new(user_id: @user.id)
        expect(power).not_to be_valid
      end
      
    end
    
    
  end

end
