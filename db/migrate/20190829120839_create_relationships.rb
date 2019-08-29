class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :follower, index: true
      t.references :followed, index: true
      t.index [:follower_id, :followed_id], unique: true

      t.timestamps
    end

    add_foreign_key :relationships, :users, column: :follower_id
    add_foreign_key :relationships, :users, column: :followed_id
  end
end
