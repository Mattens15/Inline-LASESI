class RemoveRoomHostFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :room_host, :json
  end
end
