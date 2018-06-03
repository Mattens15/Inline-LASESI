class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.boolean :fifo, deafult: true
      t.integer :max_participants
      
      t.string :address
      t.float :latitude
      t.float :longitude
      
      t.boolean :private, deafult: false
      t.time :max_unjoin_time
      
      t.string :avatar_file
      t.float :avatar_size
      t.string :avatar_updated_at
      
      t.datetime :time_from
      t.datetime :time_to
      t.string :recurrence
      t.json :event
      t.integer :event_id
      
      t.belongs_to :user
      t.timestamps
    end
  end
end
