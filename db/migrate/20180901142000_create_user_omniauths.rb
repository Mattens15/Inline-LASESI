class CreateUserOmniauths < ActiveRecord::Migration[5.2]
  def change
    create_table :user_omniauths do |t|
      t.string :name
      t.string :email
      t.string :uid

      t.timestamps
    end
  end
end
