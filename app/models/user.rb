class User < ApplicationRecord
    before_save { email.downcase! }
    validates :username, presence: true, length: { maximum: 50 }, uniqueness: true;
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence:   true,
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 8,maximum:15 }, confirmation: {case_sensitive:true}; 
    validates :password_confirmation, presence: true;

    has_many :rooms, dependent: :destroy
    has_many :powers, dependent: :destroy
    has_many :reservations, dependent: :destroy
    has_secure_password
end
