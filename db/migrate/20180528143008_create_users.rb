class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.boolean :admin
      t.json :facebook
      t.json :google
      t.json :rating
      t.json :invitations
      
      t.timestamps
    end
  end
end
