class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :type, null: false
      t.references :sender
      t.references :recipient
      t.references :product, foreign_key: true, index: true
      t.boolean :checked, default: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :sender_id
    add_foreign_key :notifications, :users, column: :recipient_id
  end
end
