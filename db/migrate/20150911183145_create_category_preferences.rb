class CreateCategoryPreferences < ActiveRecord::Migration
  def change
    create_table :category_preferences do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
