require 'rails_helper'

RSpec.describe "Prenotaziones", type: :request do
  describe "GET /prenotaziones" do
    it "works! (now write some real specs)" do
      get prenotaziones_path
      expect(response).to have_http_status(200)
    end
  end
end
