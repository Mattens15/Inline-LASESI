class Room < ApplicationRecord
  before_save{ self.event = self.update_event }
  VALID_ROOM_NAME = /[a-zA-Z]/i
  validates :user_id, presence: true
  
  validates :time_to, presence: true
  validates :time_from, presence: true
  
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
    if (current_user.id == self.user_id)
      #CREAZIONE DI UNA RELAZIONE POWER
      self.powers.create(self.id, other_user.id) 
    else
      flash[:error] = 'Non hai i diritti!'
    end
  end
  
  #SOLO IL CREATORE DELLA STANZA PUÒ USARE QUESTA FUNZIONE
  def remove_room_host(other_user)
    if(current_user.id == self.user_id)
      
      #RIMOZIONE DI UNA RELAZIONE POWER
      @association = Power.find_by user_id: other.user.id, room_id: self.id
      if(!@association.nil?)
        @association.destroy!
      else
        flash[:error] = 'L\'utente non possedeva i poteri!'
      end
    else
      flash[:error] = 'Non hai i diritti!'
    end
  end
  
  #PUÒ ESSERE LANCIATA DA QUALSIASI UTENTE
  def add_reservation(a_user)
    #UN UTENTE SI PUÒ PRENOTARE SE NON È ROOM HOST DELLA STANZA
    @power = Power.find_by user_id: a_user.id, room_id: self.id
    
    self.reservations.create(a_user.id, self.id) if @power.nil?
  end
  
  #PUÒ ESSERE LANCIATA DA UN UTENTE CON UNA PRENOTAZIONE
  def remove_reservation(a_user)
    #METODO DICHIARATO IN HELPER
    if(can_delete?)
      #RIMOZIONE DI UNA RELAZIONE RESERVATION
      @association = Reservation.find_by user_id: a_user.id, room_id: self.id
      if(!@association.nil?)
        @association.destroy!
      else
        flash[:error] = 'Non puoi eliminare una prenotazione che non esiste!'
      end
    else
      flash[:error] = 'Non puoi eliminare la prenotazione, il tuo tempo è scatudo!'
    end
  end
  
  #CREA UN EVENTO ALLA CREAZIONE DELLA ROOM
  def create_attendees_json
    attendees = []
    self.reservations.each do |r|
      attendees << {
        'email': r.user.email,
        'displayName': r.user.username
      }
    end
  end
  
  def update_event
    today = Date.today
    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_from.to_datetime.rfc3339),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_to.to_datetime.rfc3339),
      summary: self.name,
    })
  end
end
