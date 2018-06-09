class SwapReservationsController < ApplicationController
  before_action :log_in
  before_action :set_reservation_swap, except: [:index, :create]
  
  #ACTIVE USER IS THE ONE WHO SEND THE REQUEST
  #PASSIVE USER IS THE ONE WHO RECEIVE REQUEST
  def index
    @incoming = current_user.passive_swap
    @outgoing = current_user.active_swap
  end
  
  def create
    active_user = current_user
    passive_user = User.find(params[:passive_user_id])
    reservation = Reservation.find(params[:reservation_id])
    @reservation_swap = active_user.active_swap.build(passive_user: passive_user,
                                                      reservation: reservation)
    if @reservation_swap.save
      render :show, status: :create, location: @friend_request
    else
      render json: @swap_reservation.errors, status: :unprocessable_entinty
    end
  end
  
  def update
    @reservation_swap.accept
  end
  
  def destroy
    @reservation_swap.destroy!
    head :no_content
  end
  
  private
  
  def set_reservation_swap
    @reservation_swap = SwapReservation.find(params[:id])
  end
  
  def log_in
    redirect_to login_path if current_user.nil?
  end
end
