class CreateSwapReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :swap_reservations do |t|
      t.references :active_user, foreign_key: true
      t.references :passive_user, foreign_key: true
      t.references :active_reservation, foreign_key: true
      t.references :passive_reservation, foreign_key: true
      t.timestamps
    end
  end
end
