class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :user, index: true, foreign_key: true
      t.references :product, index: true, foreign_kye: true

      t.timestamps
    end
  end
end
