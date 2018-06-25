#session controller google
class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

# sessions_controller facebook
def callback
  if user = User.from_omniauth(env["omniauth.auth"])
    flash[:success] = 'Signed in by Facebook successfully'
    session[:user_id] = user.id
    redirect_to root_path
  else
    flash[:error] = "Error while signing in by Facebook. Let's register"
    redirect_to new_user_path
  end
end
