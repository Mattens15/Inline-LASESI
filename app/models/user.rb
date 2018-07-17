class User < ApplicationRecord
    attr_accessor :remember_token

    before_save { email.downcase! }
    validates :username, presence: true, length: { maximum: 50 }, uniqueness: true;
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence:   true,
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
                      
    has_secure_password
    validates :password, length: { minimum: 8,maximum:15 }, confirmation: {case_sensitive:true},allow_blank: true; 
    validates :password_confirmation, presence: true;
  
    has_many :rooms, dependent: :destroy
    
    has_many :powers, dependent: :destroy
    has_many :reservations, dependent: :destroy

    has_many :active_requests, class_name: 'SwapReservation', :foreign_key => 'active_user'
    has_many :passive_requests, class_name: 'SwapReservation', :foreign_key => 'passive_user'
    
    has_many :messages

    acts_as_messageable
    
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
end

