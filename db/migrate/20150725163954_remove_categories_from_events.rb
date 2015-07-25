class RemoveCategoriesFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :categories
  end

  def down
    add_column :events, :categories, :string
  end
end
