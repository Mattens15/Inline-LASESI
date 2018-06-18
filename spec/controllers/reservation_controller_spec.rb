require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do

  before(:each) do
    @user = FactoryBot.create(:user)
    @owner = FactoryBot.create(:owner)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
    @room_invalid_time = @owner.rooms.create!(attributes_for(:invalid_room))
    @reserved = FactoryBot.create(:user2)
  end
  
  after(:each) do
    @room.destroy!
    @owner.destroy!
    @room.destroy!
    @reserved.destroy!
    @room_invalid_time.destroy!
  end
  
  context "Creating reservation" do
    describe "as room host" do
      it "should don't let me take part" do
        params = {room_id: @room.id, user_id: @user.id}
        
        expect{post :create, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @owner.reservations.reload.count }.by(0)
      end
    end
    
    describe "as user" do
      it "should let me take part" do
        params = {room_id: @room.id, user_id: @user.id, position: 1}
        allow(controller).to receive(:logged_in_user).and_return(true)
        expect{post :create, xhr: true, params: params, format: :js}.to change {Reservation.count}.by(1)
        expect(response).to be_successful
      end
    end
    
    describe "after max unjoin time" do
      it "should don't let me take part" do
        params = {room_id: @room_invalid_time.id, user_id: @user.id}
        
        expect{post :create, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @user.reservations.reload.count }.by(0)
      end
    end
  end
  
  context "Destroying reservation" do
    
    describe "as non-reserved" do
      it "should raise record not found" do
        params = {id: 1, room_id: 5888}
        
        allow(controller).to receive(:current_user).and_return(@user);
        
        expect{delete :destroy, xhr: true, params: params, format: :js}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe "and this one is mine" do
      let!(:reservation) {Reservation.create!(room_id: @room.id, user_id: @user.id)}
      it "should delete it" do
        params = {room_id: @room.id, id: reservation}

        expect{delete :destroy, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @user.reservations.count }.by(-1)
      end
    end
    
    describe "after max_unjoin_time" do
      let!(:reservation) {Reservation.create!(room_id: @room.id, user_id: @user.id)}
      it "should do nothing" do
        @room.update(max_unjoin_time: 1.day.ago)
        params = {room_id: @room.id, id: reservation}
        allow(controller).to receive(:current_user).and_return(@user);
        
        expect{delete :destroy, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @user.reservations.count }.by(0)
      end
    end

    describe "and everything is fine" do
      let!(:reservation) {Reservation.create!(room_id: @room.id, user_id: @user.id)}
      it "should remove my reservation" do
        params = {room_id: @room.id, id: reservation}

        expect{delete :destroy, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @user.reservations.count }.by(-1)
      end
    end
  end
end
