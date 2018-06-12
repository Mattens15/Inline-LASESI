require 'rails_helper'

RSpec.describe PowersController, type: :controller do
  before(:all) do
    @user = FactoryBot.create(:user)
    @owner = FactoryBot.create(:owner)
    @room = @owner.rooms.create!(attributes_for(:valid_room))
  end
  
  after(:all) do
    @room.destroy!
  end
  
  describe "POST #create" do
    it "returns http success" do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(@owner)
      allow(controller).to receive(:correct_user).and_return(true)
      
      expect{post :create, 
            params: {room_id: @room.id, 
            user_id: @user.id}}.to change {@user.powers.count}.by(1)
      expect(response).to redirect_to(edit_room_path(@room.id))
    end
  end

  describe "GET #destroy" do
    let!(:powers){Power.create!(room_id: @room.id, user_id: @user.id)}
    it "returns http success" do
      allow(controller).to receive(:logged_in?).and_return(true)
      allow(controller).to receive(:current_user).and_return(@owner)
      allow(controller).to receive(:correct_user).and_return(true)
      
      expect{get :destroy, 
            params: {id: powers.id}
            }.to change {@user.powers.count}.by(-1)
      expect(response).to redirect_to(edit_room_path(@room.id))
      
    end
  end
  
end
