require 'rails_helper'

RSpec.describe "HasPowers", type: :request do
  describe "GET /has_powers" do
    it "works! (now write some real specs)" do
      get has_powers_path
      expect(response).to have_http_status(200)
    end
  end
end
