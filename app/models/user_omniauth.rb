class UserOmniauth < ApplicationRecord
    has_many :authorizations
    validates :name, :email, :presence => true


end
