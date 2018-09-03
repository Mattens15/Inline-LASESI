class SessionsOmniauthController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
 
  #@authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
  if UserOmniauth.find_by_email(auth_hash['info']['email'])
    user_aux=UserOmniauth.find_by_email(auth_hash['info']['email'])
    session[:user_id]=user_aux.uid
    flash[:success]="Ben tornato #{auth_hash['info']['name']} al momento tipo user: #{user_aux.getRole}!"
  else
    user = UserOmniauth.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"], :uid =>auth_hash['info']['uid']
    #user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    user.save
 
     flash[:success]="Ciao #{user.name}! sei stato registrato con successo ."
  end
  end

  def failure
    flash[:failure]="Errore nella tua autentificazione via facebook o google"
  end
  def destroy
    session[:user_id] = nil
    flash[:success]= "Logout effetuato con successo!"  
  end
  
  


end
