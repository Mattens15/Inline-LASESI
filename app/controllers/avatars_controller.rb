class AvatarsController < ApplicationController
	#before_action :set_room

	def index
		@avatars = Avatar.all
	end

	def new
		@avatar = Avatar.new
	end

	def create
		@avatar = Avatar.new(avatar_params)
		if @avatar.save
			flash[:notice] = "New avatar added!"
			redirect_to new_avatar_path
		else
			flash[:alert] = "Error during new avatar"
			render :new
		end
	end

	def destroy
		@avatar = Avatar.find(params[:id])
		if avatar.destroy
			flash[:notice] = "Avatar deleted!"
			redirect_to root_path
		else
			flash[:alert] = "Error deleting photo"
		end
		
	end

	private

		def set_room
			@room = @room || Room.find(params[:room_id])
		end

		def avatar_params
			params.require(:avatar).permit(:image)
		end
end
