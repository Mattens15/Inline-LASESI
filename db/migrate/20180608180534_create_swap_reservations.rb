class CreateSwapReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :swap_reservations do |t|
      t.references :active_user
      t.references :passive_user
      t.references :active_reservation
      t.references :passive_reservation
      t.timestamps
    end
    add_index :swap_reservations, [:active_user_id, :passive_user_id, :passive_reservation_id, :active_reservation_id], unique: true, name: 'swap_reservations_id'
  end
  
end
