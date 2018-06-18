class SwapReservation < ApplicationRecord
  belongs_to :active_user, class_name: 'User'
  belongs_to :passive_user, class_name: 'User'

  belongs_to :active_reservation, class_name: 'Reservation'
  belongs_to :passive_reservation, class_name: 'Reservation'

  validates :active_reservation_id, presence: true
  validates :passive_reservation_id, presence: true
  
  validates :active_user_id, presence: true
  validates :passive_user_id, presence: true
  
  def accept
    temp = passive_reservation.position
    passive_reservation.position = active_reservation.position
    active_reservation.position = temp
    #ADESSO CHE ABBIAMO SCAMBIATO LE POSIZIONI DISTRUGGIAMO TUTTE 
    #LE RICHIESTE ATTIVE E PASSIVE DI QUESTE PRENOTAZIONI
    passive_reservation.active_requests.destroy_all!
    passive_reservation.passive_requests.destroy_all!
    active_reservation.active_requests.destroy_all!
    active_reservation.passive_requests.destroy_all!
  end
end
