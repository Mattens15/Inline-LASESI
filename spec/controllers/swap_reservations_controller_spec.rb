require 'rails_helper'

RSpec.describe SwapReservationsController, type: :controller do
  before(:each) do
    @owner =FactoryBot.create(:owner)
    @active_user = FactoryBot.create(:user)
    @passive_user = FactoryBot.create(:user2)
    @no_reserved_user = FactoryBot.create(:user3)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
    @active_user_reservation = @active_user.reservations.create!(room_id: @room.id)
    @passive_user_reservation = @passive_user.reservations.create!(room_id: @room.id)
  end
  
  describe "Creating new swapreservation" do
    context "With all params" do
      it "should be fine" do
        allow(controller).to receive(:current_user).and_return(@active_user)
        params =  {reservation_id: @passive_user_reservation.id, room_id: @room.id}
        
        expect{         
          post :create,
          params: params
        }.to change{@active_user.active_requests.count}.by(1).
        and change{@passive_user.passive_requests.count}.by(1).
        and change(SwapReservation, :count).by(1)
        expect(response).to be_successful
      end
    end

    context "after maxunjoin time" do
      it "should not be fine" do
        allow(controller).to receive(:current_user).and_return(@active_user)
        @room.update(max_unjoin_time: 1.day.ago)

        params =  {reservation_id: @passive_user_reservation.id, room_id: @room.id}
        
        expect{         
          post :create,
          params: params
        }.to change{@active_user.active_requests.count}.by(0).
        and change{@passive_user.passive_requests.count}.by(0).
        and change(SwapReservation, :count).by(0)
        expect(response).to be_successful
      end
    end

    context "with no active reservation" do
      it "should not be fine" do
        allow(controller).to receive(:current_user).and_return(@no_reserved_user)
        params =  {reservation_id: @passive_user_reservation.id, room_id: @room.id}
        
        expect{         
          post :create,
          params: params
        }.to change{@active_user.active_requests.count}.by(0).
        and change{@passive_user.passive_requests.count}.by(0).
        and change(SwapReservation, :count).by(0)
        expect(response).to be_successful
      end
    end 

  end

  describe "delete #DESTROY" do
    let!(:swapreservation) {SwapReservation.create!(active_user_id: @active_user.id,
                                                      passive_user_id: @passive_user.id,
                                                      active_reservation_id: @active_user_reservation.id,
                                                      passive_reservation_id: @passive_user_reservation.id
                                                    )}
    it "should delete SwapReservation" do
      allow(controller).to receive(:current_user).and_return(@active_user)
      params = {room_id: @room.id, 
                reservation_id: @passive_user_reservation.id, 
                id: swapreservation.id}
      expect{
        delete :destroy,
        params: params
      }.to change{@active_user.active_requests.count}.by(-1).
      and change{@passive_user.passive_requests.count}.by(-1).
      and change(SwapReservation, :count).by(-1)
    end
  end
  
end
