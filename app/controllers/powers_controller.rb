class PowersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  skip_before_action :verify_authenticity_token
  
  
  def create
    @user = User.find(params[:user_id])
    @room = Room.find(params[:room_id])
    
    if(current_user.powers.exists?(@room))
      @user.powers.create(room_id: @room.id)
      redirect_to edit_room
    else
      flash[:error] = 'Non hai i poteri, come ci sei arrivato qui?!'
    end
      
  end

  def destroy
    @room = Powers.find(params[:room_id]).room
    @user = Powers.find(params[:user_id]).user
    if(!@room.nil? && current_user.powers.exists?(room_id: @room.id)
     @user.powers.find_by(:room_id: @room_id).destroy!
     redirect_to edit_room
    else
      flash[:error] = 'Precondizioni non valide!'
    end
  end
  
  private
    def correct_user
      @room = Room.find(params[:id])
      redirect @room unless current_user.powers.exists?(params[room_id: @room.id]) || current_user.admin?
    end
end
