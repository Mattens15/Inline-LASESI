class MapboxController < ApplicationController

	def show
    @room = Room.all
    
    roomlist = []  
    @room.each do |r|
      next if r.private && !current_user.nil? && !current_user.admin?
      roomlist << {
       :id   => r.id,
       :name => r.name,
       :description => r.description,
       :address => r.address,
       :owner => r.user_id,
       :latitude => r.latitude,
       :longitude => r.longitude,
       :time_from => r.time_from,
       :time_to => r.time_to,
       :avatar => r.avatar
      }
    end
    
    respond_to do |format|
      format.html
      format.json{
        render :json => roomlist.to_json
      }
    end
	end
end

