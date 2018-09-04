class PowersController < ApplicationController
  before_action :logged_in_user
  before_action :set_room
  before_action :correct_user
  
  skip_before_action :verify_authenticity_token
  
  
  def create
    @user = User.find_by(username: params[:power][:user_id])
    if !@user
      flash[:danger] = 'Utente non trovato!'
    else
      if @user.powers.exists?(room_id: @room.id)
        flash[:danger] = 'L\'utente ha già i poteri'
      else
        @user.powers.create!(room_id: @room.id)
        flash[:success] = 'Utente aggiunto'
      end 
    end

    respond_to do |format|
      format.html {redirect_to edit_room_path(@room)}
    end
  end

  def destroy
    @power = Power.find(params[:id])
    if @power.destroy!
      flash[:success] = 'Room host eliminato'
    else
      flash[:danger] = 'Errore eliminazione'
    end
    respond_to do |format|
      format.html {redirect_to edit_room_path(@room)}
    end
  end
  
  private

  def set_room
    @room = Room.friendly.find(params[:room_id]) unless @room
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
    
  def correct_user
    redirect_to edit_room_path(@room) unless ( current_user.rooms.exists?(@room.id) || current_user.powers.exists?(@room.id) || current_user.admin? )
  end
  
end
