class MapboxController < ApplicationController

	def show
    @room = Room.all
    
    @roomlist = []
        
    @room.each do |r|
      @roomlist << {
       :id   => r.id,
       :name => r.name,
       :description => r.description,
       :address => r.address,
       :created_by => r.created_by,
       :latitude => r.latitude,
       :longitude => r.longitude,
       :time_from => r.time_from,
       :time_to => r.time_to,
       :avatar_file => r.avatar_file,
       :avatar_size => r.avatar_size
      }
    end
    
    respond_to do |format|
      format.html
      format.json{
        render :json => @roomlist.to_json
      }
    end
	end
end

