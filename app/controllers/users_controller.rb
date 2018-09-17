class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @hashed=Digest::MD5.hexdigest(@user.id.to_s)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)    
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    auth_hash = request.env['omniauth.auth']
    if auth_hash
      User.find_by(email: auth_hash['info']['email'].downcase).destroy
    else
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to(root_url)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def invitation
    existing_user=User.find_by(email: email)
    self.user = if existing_user.present?
                  existing_user
                else
                  User.invite!(email: email)
                end
  end
  
  private

    def user_params
      params.require(:user).permit(:username,:email,:password,:password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end