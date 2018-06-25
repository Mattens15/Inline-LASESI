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
  end
end
