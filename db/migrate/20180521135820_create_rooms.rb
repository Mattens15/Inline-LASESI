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
      t.datetime :max_unjoin_time
      
      t.datetime :time_from
      t.datetime :time_to
      t.string :recurrence
      t.string :event_id
      
      t.belongs_to :user
      t.timestamps
    end
  end
end
