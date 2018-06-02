class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  default_scope -> { order('created_at') }
  
  validates :user, presence: true
  validates :room, presence: true
end
