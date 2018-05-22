class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
			flash[:success] = "Benvenuto su blogify"
			redirect_to @user
		else
			render 'new'
		end
  end
  
  def index
  end
  
  def delete
  end
  
  def destroy	
  end
  
  def user_params
      params.require(:user).permit(:email, :password, :nick, :password_confirmation)
  end
  
end
