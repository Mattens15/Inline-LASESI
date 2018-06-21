require 'rails_helper'

RSpec.describe UsersController, type: :controller do

    before(:all) do
        @user = FactoryBot.create(:user)
        @valid_attributes = FactoryBot.attributes_for(:user2)
    end

    describe "GET #new" do 
        it "should render #new view" do
            get :new
            expect(response).to render_template :new;
        end
    end

    describe "GET #show" do
        context "with valid id" do
            it "returns a success response" do
                get :show, params:{id:@user.to_param}
                expect(response).to be_successful
            end
        end
    end

    describe "POST #create" do
        it "returns a http success" do
            expect{post :create,params: {user: @valid_attributes}}.to change(User, :count).by(1)
        end
    end
end