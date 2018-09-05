class SessionsOmniauthController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
 

  if UserOmniauth.find_by_email(auth_hash['info']['email'])
     
    user_aux=UserOmniauth.find_by_email(auth_hash['info']['email'])
    
    session[:user_id]=user_aux.uid
    flash[:success]="Ben tornato #{auth_hash['info']['name']} al momento tipo user: #{user_aux.getRole}, provider:#{auth_hash['provider']}!"
    redirect_to root_url :notice=> "Signed in!!! with #{auth_hash['provider'] }"
  else
   begin 
    user = UserOmniauth.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"], :uid =>auth_hash['info']['uid']
    log_in user
    params[:session][:remember_me] == '1' ? remember(user_aux) : forget(user_aux)
    redirect_back_or user_aux
   rescue
    flash[:success]="Ciao #{user.name}! sei stato registrato con successo ."
    redirect_to root_url :notice=> "Sign up succesful"
   ensure
    user.save
   end

 
     flash[:success]="Ciao #{user.name}! sei stato registrato con successo ."
     redirect_to root_url :notice=> "Sign up succesful"
  end
  end

  def failure
    flash[:failure]="Errore nella tua autentificazione via facebook o google"
  end
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  


end
