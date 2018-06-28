require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

    before(:all) do
        @user = FactoryBot.create(:user)
    end

    describe "GET #new" do
        it "should get successful response" do
            get :new 
            expect(response).to be_successful
        end
    end

    describe "POST #create" do
        it "returns a http success" do 
            expect(post :create, params:{session: {email:"mario.rossi@gmail.com",password:"bana12345"}}).to be_successful
        end
    end

    describe "DELETE #destroy" do
        it "returns a http success" do      
            allow(controller).to receive(:logged_in?).and_return(true)
            allow(controller).to receive(:forget).and_return(true)
            delete :destroy,params:{session: {user_id:@user.id}}
            expect(session[:user_id]).to be nil
        end
    end

end
