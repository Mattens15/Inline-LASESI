json.extract! room, :id, :name, :description, :address, :created_by, :max_partecipans, :latitude, :longitude, :notes, :time_from, :time_to, :avatar_file, :avatar_size, :avatar_updated_at, :datetime, :created_at, :updated_at
json.url map_url(room, format: :json)
