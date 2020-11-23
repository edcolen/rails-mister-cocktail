class CreateCocktails < ActiveRecord::Migration[6.0]
  def change
    create_table :cocktails do |t|
      t.string :name
      t.string :category
      t.text :instructions
      t.string :glass
      t.boolean :alcoholic
      t.boolean :mixed_by_user, default: false

      t.timestamps
    end
  end
end
