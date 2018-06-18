require 'rails_helper'

RSpec.describe PowersController, type: :controller do
  before(:each) do
    @owner = FactoryBot.create(:owner)
    @user = FactoryBot.create(:user)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
  end
  
  after(:each) do
    @room.destroy!
    @owner.destroy!
    @user.destroy!
  end
  
  describe "POST #create as owner" do
    it "returns http success" do
      allow(controller).to receive(:current_user).and_return(@owner)
      
      expect{post :create, 
            params: {room_id: @room.id, 
            user_id: @user.id}}.to change {@user.powers.count}.by(1)
      expect(response).to redirect_to(edit_room_path(@room.id))
    end
  end

  describe "DELETE #destroy as owner" do
    let!(:powers){Power.create!(room_id: @room.id, user_id: @user.id)}
    it "returns http success" do
      allow(controller).to receive(:current_user).and_return(@owner)
      
      expect{delete :destroy, 
            params: {room_id: @room.id, id: powers.id}
            }.to change {@user.powers.count}.by(-1)
      expect(response).to redirect_to(edit_room_path(@room.id))
      
    end
  end
  
  describe "POST #create as non-owner" do
    it "should not be good" do
      allow(controller).to receive(:current_user).and_return(@user)
      expect{post :create, 
        params: {room_id: @room.id, 
        user_id: @user.id}}.to change {@user.powers.count}.by(0)
      expect(response).to redirect_to(edit_room_path(@room.id))
    end
  end

  describe "DELETE #destroy as non-owner" do
    let!(:powers){Power.create!(room_id: @room.id, user_id: @user.id)}
    it "returns http success" do
      allow(controller).to receive(:current_user).and_return(@user)
      
      expect{delete :destroy, 
            params: {room_id: @room.id, id: powers.id}
            }.to change {@user.powers.count}.by(0)
      expect(response).to redirect_to(edit_room_path(@room.id))
      
    end
  end
end