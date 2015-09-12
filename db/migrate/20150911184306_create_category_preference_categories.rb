class CreateCategoryPreferenceCategories < ActiveRecord::Migration
  def change
    create_table :category_preference_categories do |t|
      t.integer :category_preference_id
      t.integer :category_id

      t.timestamps
    end
  end
end
