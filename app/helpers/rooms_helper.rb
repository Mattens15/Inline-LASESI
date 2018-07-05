module RoomsHelper

  #METODO USATO PER RENDERIZZARE MAPPA SU ROOM#SHOW
  #SE L'INDIRIZZO/LATITUDINE/LONGITUDE È NULL, NON HO LOCATION
  def has_no_location
    @room = Room.friendly.find(params[:id])
    ( !@room.latitude || !@room.longitude || !@room.address )
  end
  
  #METODO USATO PER SAPERE SE POSSO EDITARE LA ROOM
  #SE SONO ADMIN O HO POTERI SI
  def do_i_matter?
    @room = Room.friendly.find(params[:id])
    current_user && (current_user.admin? || current_user.powers.exists?(room_id: @room.id))
  end
  
  #METODO USATO PER SAPERE SE POSSO PRENOTARMI
  #SE NON SONO LOGGATO, NON HO POTERI E NON HO UNA PRENOTAZIONE ESISTENZE POSSO
  def can_i_reserve?
    @room = Room.friendly.find(params[:id])
    !current_user || (!do_i_have_powers? && !current_user.reservations.exists?(room_id: @room.id))
  end
  
  #METODO USATO PER CAPIRE SE POSSO AGGIUNGERE O TOGLIERE ROOM HOST
  #SE SONO ADMIN O OWNER RITORNA TRUE
  def do_i_have_superpower?
    @room = Room.friendly.find(params[:id])
    current_user && ( current_user.admin? || @room.user.id = current_user.id )
  end
  
  #METODO USATO PER CAPIRE SE SONO ROOM HOST/OWNER
  #SE HO I POTERI TORNA TRUE (SEMI DOPPIONE DI DO_I_MATTER, USATO SOLO PER DECIDERE QUALE BOTTONE RENDERIZZARE)
  def do_i_have_powers?
    @room = Room.friendly.find(params[:id])
    current_user && current_user.powers.exists?(room_id: @room.id)
  end
  
end
