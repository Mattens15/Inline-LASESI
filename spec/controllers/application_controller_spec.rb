require 'rails_helper'
require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
	describe 'rescuee_from' do
		context 'ActiveRecord::RecordNotFound' do
			render_views
			it 'should render page 404' do
				room_id = Room.count + 10
				expect{visit "/rooms/#{room_id}"}.not_to raise_error
				
				expect(response).to render_template(:file => "#{Rails.root}/public/404.html.haml")
				expect(response).to be_successful
			end
		end

		context 'ActionController::RoutingError' do
			render_views
			it 'should render page 404' do
				expect{visit "/roooooooooooooooooooooooo"}.not_to raise_error
				
				expect(response).to render_template(:file => "#{Rails.root}/public/404.html.haml")
				expect(response).to be_successful
			end
		end
	end
end