class Message < ApplicationRecord

	belongs_to :user
	belongs_to :room

	validates :user, presence: true
	validates :room, presence: true
	validates :body, presence: true
end