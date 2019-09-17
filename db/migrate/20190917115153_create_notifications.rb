class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :content
      t.references :user, foreign_key: true, index: true
      t.references :product, foreign_key: true, index: true

      t.timestamps
    end
  end
end
