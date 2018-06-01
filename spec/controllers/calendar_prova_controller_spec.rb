require 'rails_helper'

RSpec.describe CalendarProvaController, type: :controller do

  describe "GET #calendar" do
    it "returns http success" do
      get :calendar
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #event" do
    it "returns http success" do
      get :event
      expect(response).to have_http_status(:success)
    end
  end

end
