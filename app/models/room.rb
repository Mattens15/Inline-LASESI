class Room < ApplicationRecord
  after_save{ update_event if self.event_id.nil?
              self.max_unjoin_time = self.time_from - 60*60 if self.max_unjoin_time.nil? }
              
  before_destroy{ event_destroy }
  
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
  
  #chat
  has_many :messages
  
  
  
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
    event = cal.insert_event('inline@inline-205713.iam.gserviceaccount.com', event)
    self.update(event_id: event.id)
  end
  
  
  #DISTRUGGE EVENTO SUL CALENDAR
  def event_destroy
    cal = Inline::Application.config.cal
    cal.delete_event(Rails.application.secrets.google_calendar_id, self.event_id)
  end
end
