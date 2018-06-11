require 'rails_helper'

RSpec.describe UserSignupController, type: :controller do

    describe "GET #new" do 
        it "should render #new view" do
            get :new
            expect(response).to render_template :new;
        end
    end

    describe "Users signup" do
        render_controllers

        let(:user_username) {'mario'}
        let(:user_email) {'mario.rossi@example.com'}
        let(:user_password) {'registration_test_password'}
        let(:user_passwordconfirmation) {'registration_test_password'}

        before :each do
            visit '#new'
            fill_in "user_username", with: user_username
            fill_in "user_email",	with: user_email
            fill_in "user_password",	with: user_password   
            fill_in "user_passwordconfirmation",	with: user_password_confirmation
            
            click_button 'Invia'
        end

        it "should have no empty fields on registration" do
            expect(user_username).not_to be nil
            expect(user_email).not_to be nil
            expect(user_password).not_to be nil
            expect(user_passwordconfirmation).not_to be nil
        end

       # it "should have a username of maximum 20 characters" do
end
