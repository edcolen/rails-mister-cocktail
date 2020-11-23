class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.text :description
      t.string :type
      t.boolean :alcoholic
      t.float :abv

      t.timestamps
    end
  end
end
