class RemoveRoomsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :rooms, :json
  end
end
