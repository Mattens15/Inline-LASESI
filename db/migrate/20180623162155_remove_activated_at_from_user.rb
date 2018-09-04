class RemoveActivatedAtFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :activated_at, :datetime
  end
end
