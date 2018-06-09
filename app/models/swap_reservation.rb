class SwapReservation < ApplicationRecord
  belongs_to :active_user, class_name: 'User'
  belongs_to :passive_user, class_name: 'User'
  belongs_to :active_reservation, class_name: 'Reservation'
  
  validates :active_reservation, presence: true
  validates :passive_reservation, presence: true
  validates :active_user, presence: true
  validates :passive_user, presence: true, uniqueness: { scope: :active_user }
  
  def accept
    temp = passive_reservation.position
    passive_reservation.position = active_reservation.position
    active_reservation.position = passive_reservation.position
    destroy
  end
end
