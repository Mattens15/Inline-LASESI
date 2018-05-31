class Room < ApplicationRecord
  VALID_ROOM_NAME = /[a-zA-Z]/i
  validates :user_id, presence: true
  
  
  validates :max_participants, presence: true, 
            numericality: {only_integer: true, greater_than_or_equal_to: 1}
  
  validates :name, presence: true, length: { in: 5..30 },
            format: {with: VALID_ROOM_NAME}
  validates :description, length: { maximum: 140 }
  
  belongs_to :user
  has_many :powers, dependent: :destroy
  has_many :reservations, dependent: :destroy
  
  #SOLO IL CREATORE DELLA STANZA PUÒ USARE QUESTA FUNZIONE
  def add_room_host(other_user)
    #CONTROLLO
    
    #CREAZIONE DI UNA RELAZIONE POWER
    self.powers.create(self.id, other_user.id)
  end
  
  #SOLO IL CREATORE DELLA STANZA PUÒ USARE QUESTA FUNZIONE
  def remove_room_host(other_user)
    
    #RIMOZIONE DI UNA RELAZIONE POWER
    @association = Power.find_by user_id: other.user.id, room_id: self.id
    @association.destroy! if !@association.nil?
  end
  
  #PUÒ ESSERE LANCIATA DA QUALSIASI UTENTE
  def add_reservation(an_user)
    #UN UTENTE SI PUÒ PRENOTARE SE NON È ROOM HOST DELLA STANZA
    @power = Power.find_by user_id: an_user.id, room_id: self.id
    self.reservations.create(an_user.id, self.id) if @power.nil?
  end
  
  #PUÒ ESSERE LANCIATA DA UN UTENTE CON UNA PRENOTAZIONE
  def remove_reservation(an_user)
    
    #METODO DICHIARATO IN HELPER
    if(can_delete?)
      #RIMOZIONE DI UNA RELAZIONE RESERVATION
      @association = Reservation.find_by user_id: an_user.id, room_id: self.id
      @association.destroy! if !@association.nil?
    end
  end
  
  #CREA UN EVENTO ALLA CREAZIONE DELLA ROOM
  def create_event
    self.event = {
      'summary'     => self.name,
      'description' => self.description,
      'location'    => self.address,
      'start'       => { 'dateTime' => self.time_from },
      'end'         => { 'dateTime' => self.time_to   },
      'attendees'   => []
    }
  end
end
