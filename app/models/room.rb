class Room < ApplicationRecord
  
  before_save{  
      adjust_time if self.event_id.nil?
    }

  after_save{ 
      update_event if self.event_id.nil? 
      change_unjoin_time if max_unjoin_time.nil? 
    }
    
  before_destroy{ event_destroy }
  
  VALID_ROOM_NAME = /\A[a-z0-9\s]+\Z/i
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

  

  #chat
  has_many :messages
  

  def adjust_time
    self.time_to = Time.use_zone('Europe/Rome'){ Time.zone.local_to_utc(self.time_to) }.localtime
    self.time_from = Time.use_zone('Europe/Rome'){ Time.zone.local_to_utc(self.time_from) }.localtime
  end
  
  def change_unjoin_time
    self.update(max_unjoin_time: Time.at((Time.parse(self.time_from.to_s) - 1.hour).to_i))
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
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_from.to_datetime.rfc3339, time_zone: 'Europe/Rome'),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: self.time_to.to_datetime.rfc3339, time_zone: 'Europe/Rome'),
      
      #RICCORRENZA VISIBILITÀ E PARTECIPANTI EVENTO
      #recurrence: self.recurrence,
      visibility: self.private ? 'private':'public',
    })
    cal = Inline::Application.config.cal
    #cal.authorization.update!(session[:authorization])
    if self.event_id.nil?

      event = cal.insert_event('primary', event)
      self.update(event_id: event.id)
      
    else
    
      event = cal.update_event('primary', self.event_id, event)
      self.update(event_id: event.id)
    end
  end
  
  
  #DISTRUGGE EVENTO SUL CALENDAR
  def event_destroy
    cal = Inline::Application.config.cal
    event = cal.get_event('primary', event_id)
    cal.delete_event('primary', event_id) unless event.nil?
  end
end
