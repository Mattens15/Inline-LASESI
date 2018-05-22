class CreatePrenotaziones < ActiveRecord::Migration[5.2]
  def change
    create_table :prenotaziones do |t|
      t.integer :user_id
      t.integer :room_id
      t.datetime :time_from
      t.datetime :time_to

      t.timestamps
    end
  end
end
