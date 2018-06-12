require 'rails_helper'

RSpec.describe UsersController, type: :controller do

    before(:all) do
        @valid_attributes = FactoryBot.attributes_for(:valid_room)
        @invalid_attributes = FactoryBot.attributes_for(:invalid_room_param)
        @user = FactoryBot.create(:user)
    end

    describe "GET #index" do
        it "should render #index view" do
            get :index
            expect(response).to render_template :index;
        end
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
                user=User.create!(username:"topogigio",email:"topogigio.rossi@gmail.com",password:"bananapotente",password_confirmation:"bananapotente")
                puts 'USER NIL' unless user
                get :show, params:{id:user.to_param}
                expect(response).to be_successful
            end
        end
    end
end
