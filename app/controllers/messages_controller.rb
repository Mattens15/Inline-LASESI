class MessagesController < ApplicationController
	before_action :authenticate_user!, only: [:create]
	before_action :set_room
	def index
		render :layout => false
		@messages = @room.messages
	end
	
	def create
		if current_user
			@message = @room.messages.build(message_params)
			@message.user = current_user
			
			if @message.save!
				logger.debug "YUGAUGSGUYASUYGsmessaggio creato #{@message.id} #{@message.body}".green
				respond_to do |format|
					format.html
				end
				
			else
				flash[:danger] = "Errore creazione"
			end
		end
	end

	def pin
		oldone = Message.find_by(pinned: true)
		oldone.change_pin if oldone
		newone = Message.find(params[:message_id])
		newone.change_pin
		respond_to do |format|
			format.html {redirect_to newone.room}
		end
	end

	def edit
		@to_edit=Message.find(params[:id])
		@room=Room.find_by(id: @to_edit.room_id)
		
	end

	def update
		@to_edit=Message.find(params[:id])
		@to_edit.body=params[:message][:body]
		@to_edit.save!
		respond_to do |format|
			format.html {redirect_to @to_edit.room}
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
			params.require(:message).permit(:body,:id)
		end

end