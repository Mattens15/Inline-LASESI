require 'rails_helper'

RSpec.describe PowersController, type: :controller do

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:success)
    end
  end

  context "Trying to add another room host" do
  describe "as non-owner" do
    it "should not add another room host" do
      owner = User.new(:username => 'Antonio', :email => 'danieligno10@gmail.com', :password => '12341234', :password_confirmation => '12341234')
      user = User.new(:username => 'Marco', :email => 'marco@gmail.com', :password => '12341234', :password_confirmation => '12341234')
      
      expect(owner.save).to be true
      expect(user.save).to be true
      
      room = owner.rooms.build(:name => 'Abaco', :max_participants => 1, :time_from => '2018-06-19 19:10', :time_to => '2018-06-19 22:10')
      expect(room.save).to be true
      
      expect{room.add_room_host(user, owner)}.to raise_error(RuntimeError)
    end
  end
  
  describe "as owner" do
    it "should not add another room host" do
      owner = User.new(:username => 'Antonio', :email => 'danieligno10@gmail.com', :password => '12341234', :password_confirmation => '12341234')
      user = User.new(:username => 'Marco', :email => 'marco@gmail.com', :password => '12341234', :password_confirmation => '12341234')
      
      expect(owner.save).to be true
      expect(user.save).to be true
      
      room = owner.rooms.build(:name => 'Abaco', :max_participants => 1, :time_from => '2018-06-19 19:10', :time_to => '2018-06-19 22:10')
      expect(room.save).to be true
      
      room.add_room_host(owner, user)
      
      expect(room.powers.exists?(user_id: user.id)).to be true
    end
  end

end
