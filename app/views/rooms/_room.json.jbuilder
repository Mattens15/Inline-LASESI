json.extract! room, :hash_id, :name, :description, :private, :address, :user_id, :max_participants, :latitude, :longitude, :time_from, :time_to, :max_unjoin_time, :avatar, :recurrence
json.url room_url(room, format: :html)
