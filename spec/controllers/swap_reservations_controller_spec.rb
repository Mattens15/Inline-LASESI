require 'rails_helper'

RSpec.describe SwapReservationsController, type: :controller do
  before(:each) do
    @owner =FactoryBot.create(:owner)
    @active_user = FactoryBot.create(:user)
    @passive_user = FactoryBot.create(:user2)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
    @active_user_reservation = @active_user.reservations.create!(room_id: @room.id)
    @passive_user_reservation = @passive_user.reservations.create!(room_id: @room.id)
  end

  after(:each) do
    @owner.destroy!
    @active_user.destroy!
    @passive_user.destroy!
  end

  describe "Creating new swapreservation" do
    context "With all params" do
      it "should be fine" do
        params =  {reservation_id: @passive_user_reservation.id,
                  room_id: @room.id,}
        expect{
          post :create,
          params: params
        }.to change{@active_user_reservation.active_requests.reload.count}.by(1)
      end
    end
  end
  
end
