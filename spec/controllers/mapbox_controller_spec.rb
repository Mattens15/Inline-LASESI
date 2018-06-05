require 'rails_helper'
require 'spec_helper'

RSpec.describe MapboxController, type: :controller, js: true do
  
  describe "GET #show" do
    it "should render #show view " do
      get :show
      expect(response).to render_template :show;
    end
  end
  
  describe "Map view" do
    render_views
    
    context 'loading js' do
      it 'should have all blocks allocated' do
        get :show
        expect(response.body).to have_selector('div#map')
        expect(response.body).to have_selector('div#geolocate')
        expect(response.body).to have_selector('div#geocoder')
      end
    end
    
    context 'Room' do
      it 'should have marker on div' do
        user = User.new(:username => 'Antonio', 
                        :email => 'antonellobello@gmail.com', 
                        :password => 'ciaociao', 
                        :password_confirmation => 'ciaociao')
        expect(user.save!).to be true
        room = user.rooms.create(:name => 'Anotnio\'s room', 
                                 :address => 'Rignano flaminio', 
                                 :latitude => 42, :longitude => 11, 
                                 :max_participants => 5)
                                 
        expect(user).not_to be nil
        expect(room).not_to be nil
        
        visit('/')
        
        expect(page).to have_selector('.marker')
        expect(page).to have_content("["+room.latitude+","+room.longitude+"]")
        
      end
    end
  end
end
