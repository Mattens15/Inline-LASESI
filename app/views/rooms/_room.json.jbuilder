json.extract! room, :id, :name, :description, :private, :address, :user_id, :max_participants, :latitude, :longitude, :time_from, :time_to, :avatar
json.url room_url(room, format: :json)
