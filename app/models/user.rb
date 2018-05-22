class User < ApplicationRecord
	#LA SUA FUNZIONE È DI SALVARE L'EMAIL IN DOWNCASE NEL DB
	before_save {self.email = email.downcase}
	
	#REGEX FOR VALIDATION
	
	#ACCETTA NICK CARATTERI ACCETTATI: LETTERALI NUMERI - _ \ | / . ,
	VALID_NICK_REGEX = /\A[\W\w]*\z/i
	#ACCETTA EMAIL FORMAT
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	#VALIDATES 
	validates :password, length: {minimum: 6}
	validates :nick, presence: true, length: {in: 4..20},
			  format: {with: VALID_NICK_REGEX}, 
			  uniqueness: true
	validates :email, presence: true, length: {maximum: 255},
			  format: {with: VALID_EMAIL_REGEX}, 
			  uniqueness: { case_sensitive: false }

	#AGGIUNTA PASSWORD MD5
	has_secure_password
end
