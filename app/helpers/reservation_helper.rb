module ReservationHelper
   def can_delete?
    room = Room.find(params[:id])
    room.time_from > DateTime.current
  end
end
