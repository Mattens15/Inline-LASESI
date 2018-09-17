#session controller google facebook normal user
class SessionsController < ApplicationController

  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    if auth_hash
      user = User.find_by(email: auth_hash['info']['email'].downcase)
      if user 
        
        log_in user
        redirect_back_or user
      else
        user = User.new :username => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
        user.activate

        if user.save
          
          log_in user
          redirect_back_or user
        end
      end
      
     
  
    else

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  end

  def destroy
    log_out if logged_in?
    @current_user = nil
    redirect_to root_url
  end
  
end

