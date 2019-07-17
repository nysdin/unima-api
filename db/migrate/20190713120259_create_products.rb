class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price, null: false 
      t.string :state, null: false 
      t.string :category, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
