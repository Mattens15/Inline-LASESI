class SessionsOmniauthController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
 
  @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
  if @authorization
    render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
  else
    user = UserOmniauth.new :name => auth_hash["name"], :email => auth_hash["email"]
    #user.authorization.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    user.save
 
    render :text => "Hi #{user.name}! You've signed up."
  end


  end

  def failure
  end
  def destroy
    session[:user_id] = nil
  render :text => "You've logged out!"  
  end 
end
