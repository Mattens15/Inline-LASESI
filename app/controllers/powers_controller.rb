class PowersController < ApplicationController
  before_action :logged_in_user
  before_action :set_room
  before_action :correct_user
  
  skip_before_action :verify_authenticity_token
  
  
  def create
    @user = User.find(params[:user_id])
  
    @user.powers.create!(room_id: @room.id)
    redirect_to edit_room_path(@room.id)
  
  end

  def destroy
    @power = Power.find(params[:id])
    @power.destroy!
    redirect_to edit_room_path(@power.room.id)
  end
  
  private

  def set_room
    @room = Room.find(params[:room_id]) unless @room
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
    
  def correct_user
    redirect_to edit_room_path(@room) unless current_user.rooms.exists?(@room.id) || current_user.admin?
  end
  
end
