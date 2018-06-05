class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.json :room_host
      t.boolean :admin
      t.json :rooms
      t.json :facebook
      t.json :google
      t.json :rating
      t.json :invitations

      t.timestamps
    end
  end
end
