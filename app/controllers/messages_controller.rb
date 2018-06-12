class MessagesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_room

	def create
		@message = @room.messages.new(message_params)
		@message.user = current_user
		if @message.save!
			redirect_to @room
		else
			flash[:danger] = "Errore creazione"
		end
	end


	private
		def set_room
			@room=Room.find(params[:room_id])
		end

		def authenticate_user!
			redirect_to login if !current_user
		end

		def message_params
			params.require(:message).permit(:body)
		end
end