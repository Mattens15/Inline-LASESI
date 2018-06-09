class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  has_many :active_request,   through: :swap_reservations, source: :active_reservation
  has_many :passive_request,  through: :swap_reservations, source: :passive_reservation
  
  default_scope -> { order('created_at') }
  
  validates :user, presence: true
  validates :room, presence: true
end
