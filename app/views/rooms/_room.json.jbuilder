json.extract! room, :id, :name, :description, :address, :user_id, :max_participants, :latitude, :longitude, :time_from, :time_to, :avatar_file, :avatar_size, :avatar_updated_at, :created_at, :updated_at
json.reservations room.reservations, partial: 'rooms/reservations', as: :reservation
json.url room_url(room, format: :json)
