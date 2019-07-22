class AddStatusToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :status, :string, default: "open", null: false
  end
end
