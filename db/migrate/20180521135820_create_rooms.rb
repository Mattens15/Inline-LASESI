class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.string :notes
      t.integer :max_partecipans
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :created_by
      t.datetime :time_from
      t.datetime :time_to
      t.string :avatar_file
      t.float :avatar_size
      t.string :avatar_updated_at
      t.string :datetime

      t.timestamps
    end
  end
end
