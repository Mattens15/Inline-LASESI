class Room < ApplicationRecord
  after_save{ self.event = self.update_event }
  before_destroy{ self.event_destroy }
  
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
  def add_room_host(performer, other_user)
    #CONTROLLO
    if (performer.id == self.user_id || performer.admin?)
      #CREAZIONE DI UNA RELAZIONE POWER
      self.powers.create(user_id: performer.id)
    end
  end
  
  #SOLO IL CREATORE DELLA STANZA PUÒ USARE QUESTA FUNZIONE
  def remove_room_host(performer, other_user)
    @association = other_user.powers.find(self)
    if((performer.id == self.user_id  || permormer.admin?) && !@association.nil?)
      #RIMOZIONE DI UNA RELAZIONE POWER
      @association.destroy!
    else
      raise 'Non hai i diritti!'
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
      organizer: {email: self.user.email, display_name: self.user.username},
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_from.to_datetime.rfc3339),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_to.to_datetime.rfc3339),
      
      #RICCORRENZA VISIBILITÀ E PARTECIPANTI EVENTO
      #recurrence: self.recurrence,
      visibility: self.private ? 'private':'public',
      #attendees: render_attendees
    })
    cal = Inline::Application.config.cal
    event = cal.insert_event('inline@inline-205713.iam.gserviceaccount.com', event)
    self.event = event
    self.event_id = event.id
    logger.debug "ID EVENTO: #{self.event_id}"
  end
  
  
  #DISTRUGGE EVENTO SUL CALENDAR
  def event_destroy
    cal = Inline::Application.config.cal
    cal.delete_event(Rails.application.secrets.google_calendar_id, self.event_id, true)
  end
end
