class UserOmniauth < ApplicationRecord
    has_many :authorizations
    validates :name, :email, :presence => true
    

    enum role: [:user_normale, :admin]
    #after_initialize :set_default_role, :if => :new_record?

    def set_default_role
      self.role ||= :user_normale
    end

    def getRole
       if(self.admin?)
        return "admin"
       else
        return "user normale"
       end
        
    end

    

end
