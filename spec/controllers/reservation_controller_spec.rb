require 'rails_helper'

RSpec.describe ReservationsController, type: :controller do
  context "Creating reservation" do
    describe "as room host" do
      it "should don't let me" do
        user = User.new(:username => 'Marco', :email => 'marco@gmail.com', :password => '12341234', :password_confirmation => '12341234')
        expect(user.save!).to be true
        
        room = user.rooms.build(:name => 'Abaco', :max_participants => 1, :time_from => '2018-06-19 19:10', :time_to => '2018-06-19 22:10')
        expect(room.save!).to be true
        
        allow(controller).to receive(:current_user).and_return(user);
        post :create, id: @room.id
        expect(user.reservations.exists?(room_id: @room.id)).to be true
      end
    end
  end
end
