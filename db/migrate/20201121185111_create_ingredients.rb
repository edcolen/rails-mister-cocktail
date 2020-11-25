class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.references :user, foreign_key: true

      t.string :name, null: false
      t.text :description, null: false
      t.string :type, null: false
      t.string :alcoholic, default: true
      t.string :abv, precision: 10, scale: 2, default: 0.0
      t.boolean :added_by_user, default: false

      t.timestamps
    end
  end
end
