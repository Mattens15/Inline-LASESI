class MessagesController < ApplicationController
	before_action :authenticate_user!, only: [create]
	before_action :set_room
	def index
		render :layout => false
		@messages = @room.messages
	end
	
	def create
		@message = @room.messages.new(message_params)
		@message.user = current_user
		if @message.save!
			
		else
			flash[:danger] = "Errore creazione"
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