class MessagesController < ApplicationController
	before_action :set_room

	def index
		render :layout => false
		@messages = @room.messages
	end
	
	def create
		@message = @room.messages.build(message_params)
		@message.user = current_user
		if !@message.save
			flash[:danger] = "Errore creazione"
		end

		respond_to do |format|
			format.html
		end

	end


	private
		def set_room
			@room = Room.friendly.find(params[:room_id])
		end

		def authenticate_user!
			redirect_to login_path if !current_user
		end

		def message_params
			params.require(:message).permit(:body)
		end
end