class MapboxController < ApplicationController

	def show
    @room = Room.all
    roomlist = []  
    @room.each do |r|
      next if r.private && !(current_user && !current_user.admin?)
      
      room_host = []
      r.powers.each do |pow|
        room_host << {
          :id => pow.user_id,
          :username => User.find(pow.user_id).username,
          :url => user_path(pow.user_id)
        }
      end
  
      roomlist << {
       :id   => r.hash_id,
       :name => r.name,
       :description => r.description,
       :address => r.address,
       :latitude => r.latitude,
       :longitude => r.longitude,
       :avatar => r.avatar,
       :room_host => room_host
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

