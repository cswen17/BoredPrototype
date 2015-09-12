class AddCategoryPreferenceToUser < ActiveRecord::Migration
  def up
    add_column :category_preferences, :user_id, :integer
  end

  def down
    remove_column :category_preferences, :user_id, :integer
  end
end
