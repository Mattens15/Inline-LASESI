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
      if !User.find(params[:user_id]).reservations.exists?(room_id: @room.id) && @reservation.save!
        flash.now[:success] = 'Prenotazione effettuata'
      else
        flash.now[:warning] = 'Errore! Qualcosa è andato storto'
      end

    else
      if(@room.powers.exists?(user_id: @reservation.user_id)) 
        flash.now[:danger] = 'Errore! Sei un room host!'
      elsif(@room.reservations.count > @room.max_participants)
        flash.now[:danger] = 'Errore! Coda piena'
      else
        flash.now[:danger] = 'Errore! Tempo scaduto'
      end
    end
    
    respond_to do |format|
      format.js
    end
    
  end
  

  def update

    if params[:reminder]
      flash.now[:success] = 'Reminder aggiornato!'
      @reservation.update(reminder: params[:reminder])
    else
      flash.now[:success] = 'Posizione aggiornata!'
      @reservation.update(position: params[:position])
    end
    
  end

  def destroy
    if(@room.nil? || @room.max_unjoin_time < Time.now)
      flash.now[:danger] = 'Non eri in coda il tempo per cancellare la prenotazione è scaduto!'
    else
      @position = @reservation.position
      @reservation.destroy!
      flash.now[:success] = 'Prenotazione cancellata!'
    end

    respond_to do |format|
      format.html
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
      @room = Room.friendly.find(params[:room_id])
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash.now[:danger] = "Devi essere loggato per eseguire l'azione"
        redirect_to login_url
      end
    end
end
