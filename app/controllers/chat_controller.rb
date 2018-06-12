class MessageController < ApplicationController
	before_action :authenticate_user!
	before_action :set_room

	def create
		message = @room.messages.new(message_params)
		message.user = current_user
		
	end


	private
		def set_room
			@room=Room.find(params[:id])
		end
		
		def message_params
			params.require(:message).permit(:body)
		end
end