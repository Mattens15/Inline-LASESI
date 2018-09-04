class Authorization < ApplicationRecord
       belongs_to :user_omniauth
       validates :provider, :uid, :presence => true


       

end
