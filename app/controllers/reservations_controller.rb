class ReservationsController < ApplicationController
  before_action :logged_in_user
  skip_before_action :verify_authenticity_token
  
  def create
    @room = Room.find(params[:room_id])
    if(current_user != @room.user)
      current_user.reservations.create(room_id: @room.id)
    else
      flash[:danger] = 'Can\'t join if you are a room host!'
    end
    
    respond_to do |format|
      format.html {@room}
      format.js 
    end
    
  end

  def update
  end

  def destroy
    @room = Reservation.find(params[:id]).room
    if(@room.nil?)
      flash[:danger] = 'You was not in queue!'
    else
      current_user.reservations.find_by(room_id: @room.id).destroy!
    end
    respond_to do |format|
      format.html { redirect_to @room}
      format.js
    end
  end
  
  private
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
