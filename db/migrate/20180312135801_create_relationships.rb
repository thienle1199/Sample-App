class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :follwed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :follwed_id
    add_index :relationships, [:follower_id, :follwed_id], unique: true
  end
end
