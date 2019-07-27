class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.integer :price, null: false 
      t.string :state, null: false 
      #trade condition -- open, trade, close --
      t.string :status, default: "open", null: false
      t.references :buyer
      t.references :seller
      t.datetime :traded_at
      t.datetime :closed_at

      t.timestamps
    end
    add_foreign_key :products, :users, column: :seller_id
  end
end
