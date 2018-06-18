class ReservationsController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :set_room
  before_action :correct_user, only: [:destroy, :update]
  skip_before_action :verify_authenticity_token

  def index
    render :layout => false
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def create
    @reservation = @room.reservations.new(:user_id => params[:user_id], :position => params[:position])
    if(checkValidation)
      if @reservation.save!
        respond_to do |format|
          format.js
          format.html
        end
      else
        respond_to do |format|
          format.js {render :js => "alert('Errore! Qualcosa è andato storto!');"}
        end
      end

      

    else
      if(@room.powers.exists?(user_id: @reservation.user_id)) 
        respond_to do |format|
          format.js {render :js =>  "alert('Errore! Sei un room host!');"}
        end
      elsif(@room.reservations.count > @room.max_participants)
        respond_to do |format|
          format.js {render :js =>  "alert('Errore! Coda piena');"}
        end
      else
        respond_to do |format|
          format.js {render :js =>  "alert('Errore! Tempo scaduto!');"}
        end
      end
      
    end
    
  end
  

  def update
    @reservation.update(reminder: params[:reminder])
  end

  def destroy
    if(@room.nil? || @room.max_unjoin_time < Time.now)
      flash[:danger] = 'You was not in queue or the time has expired!'
    else
      @position = @reservation.position
      @reservation.destroy!
    end
    respond_to do |format|
      format.html { redirect_to @room}
      format.js
    end
  end
  
  private
    def correct_user
      @reservation = Reservation.find(params[:id])
      redirect_to @room unless !current_user || @reservation.user_id == current_user.id || current_user.powers.exists?(room_id: @room.id) || current_user.admin?
    end

    def checkValidation
      !@room.powers.exists?(user_id: @reservation.user_id) && @room.reservations.count < @room.max_participants && DateTime.current < @room.max_unjoin_time
    end

    def set_room
      @room = Room.find(params[:room_id])
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
