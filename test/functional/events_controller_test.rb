require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  fixtures :events
  fixtures :users
  setup do
    @event = FactoryGirl.build(:event)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

# test "should create event" do
#   assert_difference('Event.count') do
#     post :create, event: @event.attributes
#   end

#   assert_redirected_to event_path(assigns(:event))
# end

  test "should show event" do
    get :show, id: @event.id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event.id
    assert_response :success
  end

# test "should update event" do
#   updated_event = events(:one)
#   updated_event.location = "Doherty Hall"
#   put :update, id: updated_event.id, event: updated_event.attributes
#   assert_redirected_to events_my_path()
# end

  test "should destroy event" do
    existing_event_to_destroy = events(:one)
    assert_difference('Event.count', -1) do
      delete :destroy, id: existing_event_to_destroy.id
    end

    assert_redirected_to events_path
  end
end
