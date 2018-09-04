require 'rails_helper'

RSpec.describe PowersController, type: :controller do
  before(:each) do
    @owner = FactoryBot.create(:owner)
    @user = FactoryBot.create(:user)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
  end
  
  describe "POST #create as room host" do
    it "returns http success" do
      allow(controller).to receive(:current_user).and_return(@owner)
      
      expect{post :create, 
            params: {room_id: @room.id, power: {user_id: @user.username}}}.to change {@user.powers.count}.by(1)
      expect(response).to redirect_to(edit_room_path(@room.hash_id))
    end
  end

  describe "DELETE #destroy as room host" do
    let!(:powers){Power.create!(room_id: @room.id, user_id: @user.id)}
    it "returns http success" do
      allow(controller).to receive(:current_user).and_return(@owner)
      
      expect{delete :destroy, 
            params: {room_id: @room.id, id: powers.id}
            }.to change {@user.powers.count}.by(-1)
      expect(response).to redirect_to(edit_room_path(@room.hash_id))
      
    end
  end
  
  describe "POST #create as non-room host" do
    it "should not be good" do
      allow(controller).to receive(:current_user).and_return(@user)
      expect{post :create, 
        params: {room_id: @room.id, 
        user_id: @user.id}}.to change {@user.powers.count}.by(0)
      expect(response).to redirect_to(edit_room_path(@room.hash_id))
    end
  end

  describe "DELETE #destroy as non-room host" do
    it "returns http success" do
      allow(controller).to receive(:current_user).and_return(@user)
      
      expect{delete :destroy, 
            params: {room_id: @room.id, id: @room.powers.take.id}
            }.to change {@user.powers.count}.by(0)
      expect(response).to redirect_to(edit_room_path(@room.hash_id))
    end
  end
end