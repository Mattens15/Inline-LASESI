class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :username
      t.string  :email
      t.string  :password
      t.boolean :admin
      t.json    :room_host
      t.json    :facebook
      t.json    :google
      t.json    :ratings
      t.json    :invitations
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
