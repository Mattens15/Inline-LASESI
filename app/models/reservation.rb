class Reservation < ApplicationRecord
  before_save {self.position = room.reservations.count + 1 if self.position.nil?}
  belongs_to :user
  belongs_to :room
  
  has_many :active_request,   through: :swap_reservations, source: :active_reservation
  has_many :passive_request,  through: :swap_reservations, source: :passive_reservation
  
  default_scope -> { order('position') }
  
  validates :user, presence: true
  validates :room, presence: true
end
