class CreateCocktails < ActiveRecord::Migration[6.0]
  def change
    create_table :cocktails do |t|
      t.references :user, null: false, foreign_key: true

      t.string :name, null: false
      t.string :category, null: false
      t.integer :ratings
      t.text :instructions, null: false
      t.string :glass, null: false
      t.string :alcoholic, default: 'alcoholic'
      t.boolean :mixed_by_user, default: false

      t.timestamps
    end
  end
end
