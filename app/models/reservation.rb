class Reservation < ApplicationRecord
  before_save {setPosition}
  belongs_to :user
  belongs_to :room
  
  has_many :active_requests, class_name: 'SwapReservation', foreign_key: 'active_reservation_id'
  has_many :passive_requests, class_name: 'SwapReservation', foreign_key: 'passive_reservation_id'
  
  default_scope -> { order('position') }
  
  validates :user, presence: true
  validates :room, presence: true

  def setPosition
    self.position = room.reservations.count + 1 if self.position.nil?
  end
end
