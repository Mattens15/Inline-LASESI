module ReservationHelper
   def can_delete?
    room = Room.find(params[:id])
    DateTime.current < room.max_unjoin_time
  end
end
