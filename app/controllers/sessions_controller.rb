# sessions_controller
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
