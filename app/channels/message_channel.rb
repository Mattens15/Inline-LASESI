class MessageChannel < ApplicationCable::Channel
  def subscribed

  	stream_from "room:#{@room.id}"
    
  end

  def unsubscribed
    stop_all_streams
  end
end
