module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :current_user
  end

  def connect
  	self.current_user= find_verified_user
  end

  protected
  	def find_veriefied_user
  		if current_user=env['warden'].usere
  			current_user
  		else
  			reject_authorized_connection
  		end

    end
end
