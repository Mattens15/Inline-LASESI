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

    describe "PUT update/:id" do
        let(:attr) do
            {:username => 'mario',:email => 'mario.rossi@gmail.com',:password =>'12345678',:password_confirmation=>'12345678'}
        end

        before(:each) do
            allow(controller).to receive(:current_user).and_return(@user)
            allow(controller).to receive(:logged_in_user).and_return(true)
            put :update, params:{id: @user.id,user: attr}
            @user.reload
        end

        it{expect(response).to redirect_to(@user)}
        it{expect(@user.username).to eql attr[:username]}
        it{expect(@user.email).to eql attr[:email]}
    end

    describe "DELETE destroy/:id" do
        before(:each) do
            allow(controller).to receive(:current_user).and_return(@user)
            allow(controller).to receive(:logged_in_user).and_return(true)
            expect{delete :destroy,params:{id: @user.id}}.to change(User, :count).by(-1)
        end
    end
end