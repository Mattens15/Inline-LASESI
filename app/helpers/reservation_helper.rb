module ReservationHelper
   def can_delete?
    room = Room.find(params[:id])
    DateTime.current < room.time_from
  end
end
