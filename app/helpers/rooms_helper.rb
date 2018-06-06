module RoomsHelper
  #CONFRONTA CURRTIME CON IL MAX UNJOIN TIME
  def has_no_location
    @room = Room.find(params[:id])
    ( @room.latitude.nil? || @room.longitude.nil? || @room.address.nil? )
  end
  
  def do_i_matter?
    @room = Room.find(params[:id])
    current_user.admin? || current_user.powers.exists?(room_id: @room.id)
  end
  
  def do_i_have_superpower?
    @room = Room.find(params[:id])
    ( current_user.admin? || @room.user.id = current_user.id )
  end
end
