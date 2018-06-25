require 'rails_helper'

RSpec.describe SwapReservation, type: :model do
  before(:each) do
    @owner =FactoryBot.create(:owner)
    @active_user = FactoryBot.create(:user)
    @passive_user = FactoryBot.create(:user2)
    @no_reserved_user = FactoryBot.create(:user3)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
    @active_user_reservation = @active_user.reservations.create!(room_id: @room.id)
    @passive_user_reservation = @passive_user.reservations.create!(room_id: @room.id)
  end

  after(:each) do
    @owner.destroy!
    @active_user.destroy!
    @passive_user.destroy!
  end

  describe "Creating new SwapReservation" do
    context "With valid params" do
      it "should be fine" do
        expect(SwapReservation.new(active_user_id: @active_user.id,
          passive_user_id: @passive_user.id,
          active_reservation_id: @active_user_reservation.id,
          passive_reservation_id: @passive_user_reservation.id
        )).to be_valid
      end
    end

    context "With invalid params" do
      it "should not be fine" do
        expect(SwapReservation.new(
          active_user_id: @active_user.id,
          active_reservation_id: 558,
          passive_reservation_id: @passive_user_reservation.id
        )).not_to be_valid
      end
    end
  end
  
  describe "Acception request" do
    it "should change position" do
      swapreservation = SwapReservation.create!(active_user_id: @active_user.id,
        passive_user_id: @passive_user.id,
        active_reservation_id: @active_user_reservation.id,
        passive_reservation_id: @passive_user_reservation.id
      )
      active_pos = @active_user_reservation.position
      passive_pos = @passive_user_reservation.position

      expect{swapreservation.accept}.to change{@active_user_reservation.reload.position}.
      from(active_pos).to(passive_pos).
      and change{@passive_user_reservation.reload.position}.
      from(passive_pos).to(active_pos)
      
      expect(@active_user_reservation.active_requests.count).to eq(0)
      expect(@active_user_reservation.passive_requests.count).to eq(0)

      expect(@passive_user_reservation.active_requests.count).to eq(0)
      expect(@passive_user_reservation.passive_requests.count).to eq(0)

    end
  end
  
end
