require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  fixtures :categories
  def test_index
    # Tests that we can fetch all categories
    get :index
    assigns_categories = assigns(:categories)

    assert_response :ok

    assert_not_nil assigns_categories
    assert_includes ["Arts", "Sports", "Professional"], assigns_categories[0].name
    assert_includes ["Arts", "Sports", "Professional"], assigns_categories[1].name
    assert_includes ["Arts", "Sports", "Professional"], assigns_categories[2].name
    assert_equal 3, assigns_categories.length
  end
  
  def test_create
    # Tests that we can create a category
    post :create, category: { name: "Movies" }

    assert_response :found

    assert_not_nil Category.find_by_name("Movies")
  end

  def test_destroy
    # Tests that we can destroy a category
    category_to_destroy = categories(:one)
    delete :destroy, id: category_to_destroy.id

    assert_nil Category.find_by_name(category_to_destroy.name)
  end
end
