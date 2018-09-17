class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.text :body
      t.boolean :pinned, default: false
    end
  end
end
