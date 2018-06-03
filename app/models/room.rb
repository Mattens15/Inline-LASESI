class Room < ApplicationRecord
  after_save{ self.event = self.update_event }
  before_destroy{ self.event_destroy }
  
  VALID_ROOM_NAME = /[a-zA-Z]/i
  #validates :user_id, presence: true
  
  validates :time_to, presence: true
  validates :time_from, presence: true
  
  validates :max_participants, presence: true, 
            numericality: {only_integer: true, greater_than_or_equal_to: 1}
  
  validates :name, presence: true, length: { in: 5..30 },
            format: {with: VALID_ROOM_NAME}
  validates :description, length: { maximum: 140 }
  
  #belongs_to :user
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
  def add_reservation
    #UN UTENTE SI PUÒ PRENOTARE SE NON È ROOM HOST DELLA STANZA
    @power = Power.find_by user_id: current_user.id, room_id: self.id
    self.reservations.create(current_user.id, self.id) if @power.nil?
    update_event
  end
  
  #PUÒ ESSERE LANCIATA DA UN UTENTE CON UNA PRENOTAZIONE
  def remove_reservation
    #METODO DICHIARATO IN HELPER
    if(can_delete?)
      #RIMOZIONE DI UNA RELAZIONE RESERVATION
      @association = Reservation.find_by user_id: cuurent_user.id, room_id: self.id
      if(!@association.nil?)
        @association.destroy!
        update_event
      else
        flash[:error] = 'Non puoi eliminare una prenotazione che non esiste!'
      end
    else
      flash[:error] = 'Non puoi eliminare la prenotazione, il tuo tempo è scatudo!'
    end
  end
  
  #CREA UN EVENTO ALLA CREAZIONE DELLA ROOM
  def update_event
    
    event = Google::Apis::CalendarV3::Event.new({
      #NOME DESCRIZIONE E LOCATION DELL'EVENTO
      summary: self.name,
      description: self.description,
      location: self.address,
      
      #DATI DEL CREATORE, INIZIO EVENTO, FINE EVENTO
      #organizer: Google::Apis::CalendarV3::Event::Creator,
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_from.to_datetime.rfc3339),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_to.to_datetime.rfc3339),
      
      #RICCORRENZA VISIBILITÀ E PARTECIPANTI EVENTO
      #recurrence: self.recurrence,
      visibility: self.private ? 'private':'public',
      attendees: self.render_attendees,
    })
    
    cal = Inline::Application.config.cal
    self.event = event
    logger.debug event
    logger.debug self.event
    if(self.event_id.nil?)
      
      event = cal.insert_event('inline@inline-205713.iam.gserviceaccount.com', event)
      self.event = event
      self.event_id = event.id
    else
      cal.update_event(Rails.application.secrets.google_calendar_id, self.event_id)
    end
    
    
  end
  
  #COSTRUISCE ARRAY DI PARTECIPANTI DA USARE NELL' UPDATE_EVENT
  def render_attendees
    attendees = []
    logger.debug self.reservations
    self.reservations.each do |r|
      attendees << Google::Apis::CalendarV3::EventAttendee(display_name: current_user.username, email: current_user.email)
    end
  end
  
  #DISTRUGGE EVENTO SUL CALENDAR
  def event_destroy
    cal = Inline::Application.config.cal
    cal.delete_event(Rails.application.secrets.google_calendar_id, self.event_id, true)
  end
end
