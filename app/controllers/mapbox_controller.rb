class MapboxController < ApplicationController

	def show
    @room = Room.all
    
    roomlist = []  
    @room.each do |r|
      next if r.private && (!current_user || !current_user.admin?)
      roomlist << {
       :id   => r.hash_id,
       :name => r.name,
       :description => r.description,
       :address => r.address,
       :latitude => r.latitude,
       :longitude => r.longitude,
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

