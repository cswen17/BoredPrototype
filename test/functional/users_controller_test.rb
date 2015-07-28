require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # Thank you so much to:
  # stackoverflow.com/questions/523771/
  # why-are-my-fixture-objects-not-available-in-my-rails-testunit-test
  # for helping me put the following line here to get the tests to work
  fixtures :users
  setup do
    @user = FactoryGirl.build(:user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: @user.attributes
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user.id
    assert_response :success
  end

  test "should update user" do
    # Original name was David, we'll update it to Bob
    user_to_update = users(:one)
    user_to_update.first_name = "Bob"
    put :update, id: user_to_update.id, user: user_to_update.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      user_to_destroy = users(:one)
      delete :destroy, id: user_to_destroy.to_param
    end

    assert_redirected_to users_path
  end
end
