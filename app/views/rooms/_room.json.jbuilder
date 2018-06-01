json.extract! room, :id, :name, :description, :address, :user_id, :max_participants, :latitude, :longitude, :time_from, :time_to, :avatar_file, :avatar_size, :avatar_updated_at, :datetime, :created_at, :updated_at, :event
json.url room_url(room, format: :json)
