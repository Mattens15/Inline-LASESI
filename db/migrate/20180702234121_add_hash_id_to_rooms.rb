class AddHashIdToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :hash_id, :string, index: true
    Room.all.each{|m| m.set_hash_id; m.save}
  end
end
