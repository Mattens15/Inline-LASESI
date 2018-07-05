class CalendarsController < ApplicationController

  before_action :authentication, only: [:add_event]
  before_action :logged_in?

  def redirect
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri.to_s
  end

  def callback
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!
    session[:authorization] = response
    redirect_to room_path(cookies[:room_id])
  end

  def add_event
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])
    
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    cal = Inline::Application.config.cal
    @room = Room.friendly.find(cookies[:room_id])

    service.insert_event('primary', create_event(@room))
    flash[:success] = 'Evento aggiunto'
    redirect_to @room
  rescue Google::Apis::AuthorizationError
    redirect
  end
  
  private
  def create_event(room)
    Google::Apis::CalendarV3::Event.new({
      #NOME DESCRIZIONE E LOCATION DELL'EVENTO
      summary: room.name,
      description: room.description,
      location: room.address,
      
      #DATI DEL CREATORE, INIZIO EVENTO, FINE EVENTO
      organizer: {email: room.user.email, display_name: room.user.username},
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: room.time_from.to_datetime.rfc3339),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: room.time_to.to_datetime.rfc3339),
      
      #RICCORRENZA VISIBILITÀ E PARTECIPANTI EVENTO
      visibility: room.private ? 'private':'public'
    })
  end
  
  def authentication
    cookies[:room_id] = params[:room_id]
    puts "ROOM_ID: #{params[:room_id]}"
    redirect_to redirect_path unless session[:authorization]
  end

  def logged_in?
    redirect_to login_path unless current_user
  end

  def client_options
    {
      client_id:      "696250805146-es9ikhh86ujmq7aqa3j97ghd1s90r352.apps.googleusercontent.com",
      client_secret:  "SpWMuUnbGS9QI1fhJatX7Fza",
      authorization_uri:    'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope:          Google::Apis::CalendarV3::AUTH_CALENDAR,  
      redirect_uri:   'http://localhost:3000/callback'
    }
  end
end
 