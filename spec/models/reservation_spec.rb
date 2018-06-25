require 'rails_helper'

RSpec.describe Reservation, type: :model do
  before(:each) do
    @owner = FactoryBot.create(:owner)
    @room = @owner.rooms.create(attributes_for(:valid_room))
    @user = FactoryBot.create(:user)
  end

  context "Create reservation" do
    describe "without room" do
      it "should not be valid"do
        @reservation = Reservation.new(user_id: @user.id)
        expect(@reservation).not_to be_valid
      end
    end

    describe "without user" do
      it "should not be valid"do
        @reservation = @room.reservations.build
        expect(@reservation).not_to be_valid
      end
    end

    describe "with position" do
      it "should be valid"do
        @reservation = @room.reservations.build(user_id: @user.id, position: 2)
        expect(@reservation).to be_valid
        expect(@reservation.position).to be(2)
      end
    end

    describe "without position" do
      it "should be valid"do
        @reservation = @room.reservations.build(user_id: @user.id)
        expect(@reservation).to be_valid
        expect(@reservation.save!).to be true
        expect(@reservation.position).to eq(@room.reservations.count)
      end
    end
  
  end
end
