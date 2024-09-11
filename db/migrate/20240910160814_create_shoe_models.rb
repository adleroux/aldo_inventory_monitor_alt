class CreateShoeModels < ActiveRecord::Migration[7.2]
  def change
    create_table :shoe_models do |t|
      t.string :name

      t.timestamps
    end
  end
end
