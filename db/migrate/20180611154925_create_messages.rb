class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages,:id=>false do |t|
      t.references :room, foreign_key: true
      t.references :user, foreign_key: true
      t.integer "id"
      t.boolean "pinned", default: false
      t.text :body

      t.timestamps
    end
  end
end