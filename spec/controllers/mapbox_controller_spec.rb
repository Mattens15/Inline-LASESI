require 'rails_helper'
require 'spec_helper'

RSpec.describe MapboxController, type: :controller do
  describe "GET #show" do
    it "should render #show view " do
      get :show
      expect(response).to render_template :show;
    end
  end
  
end
