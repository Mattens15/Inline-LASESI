require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  before(:all) do
    @user = FactoryBot.create(:user)
    @owner = FactoryBot.create(:owner)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
    @room_invalid_time = @owner.rooms.create!(attributes_for(:invalid_room))
  end

  context "Creating reservation" do
    describe "as room host" do
      it "should don't let me take part" do
        params = {room_id: @room.id}
        
        allow(controller).to receive(:current_user).and_return(@owner);
        expect{post :create, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @owner.reservations.reload.count }.by(0)
      end
    end
    
    describe "as user" do
      it "should let me take part" do
        params = {room_id: @room.id}
        
        allow(controller).to receive(:current_user).and_return(@user);
        
        expect{post :create, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @user.reservations.reload.count }.by(1)
      end
    end
    
    describe "after max unjoin time" do
      it "should don' let me take part" do
        params = {room_id: @room_invalid_time.id}
        allow(controller).to receive(:current_user).and_return(@user);
        
        expect{post :create, 
              xhr: true,
              params: params, 
              format: :js
        }.to change { @user.reservations.reload.count }.by(0)
      end
    end
  end
end
