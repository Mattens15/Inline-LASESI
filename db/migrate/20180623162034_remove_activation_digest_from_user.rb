class RemoveActivationDigestFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :activation_digest, :string
  end
end
