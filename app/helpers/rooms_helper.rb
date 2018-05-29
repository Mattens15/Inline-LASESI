module RoomsHelper
  #CONFRONTA CURRTIME CON IL MAX UNJOIN TIME
  def can_delete?(room)
    return room.max_unjoin_time > Time.now
  end
end
