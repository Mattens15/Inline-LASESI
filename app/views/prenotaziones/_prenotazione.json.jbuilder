json.extract! prenotazione, :id, :user_id, :room_id, :time_from, :time_to, :created_at, :updated_at
json.url prenotazione_url(prenotazione, format: :json)
