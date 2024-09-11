class CreateInventories < ActiveRecord::Migration[7.2]
  def change
    create_table :inventories do |t|
      t.references :store, null: false, foreign_key: true
      t.references :shoe_model, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
