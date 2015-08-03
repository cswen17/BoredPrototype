require 'test_helper'

class CategoriesTest < ActiveSupport::TestCase
  def test_save_category
    # Asserts that we can create and save a category
    category = Category.new(
      :name => 'Coding Contests'
    )
    category.save

    assert_empty category.errors
  end
end
