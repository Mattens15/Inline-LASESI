class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
    
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.boolean :reminder, default: false
      
      t.timestamps
    end
    add_index :reservations, [:user_id, :room_id], unique: true
  end
end
