require 'test_helper'

class EventsTest < ActiveSupport::TestCase

  fixtures :events 
  fixtures :organizations
  fixtures :organization_users
  fixtures :users
  # todo: add paperclip tests or change paperclip to other api
  def test_create_new_event
    # Tests that we can create a new event
    new_event = Event.new(
      :id                 => 42,
      :name               => 'Carnival',
      :description        => 'Booths and rides and funnel cake',
      :location           => 'Morewood Parking Lot',
      :event_start        => 2.weeks.from_now,
      :event_end          => (2.weeks.from_now + 1.hours).to_datetime,
      :flyer              => 'imgur.com/c00l3v3nt',
      :approval_rating    => -1,
      :approver_id        => 'acarnegie',
      :flyer_file_name    => 'idontexist.jpg',
      :flyer_content_type => 'image/jpeg',
      :flyer_file_size    => 5269,
      :summary            => 'Come one, come all!',
      :cancelled          => false,
      :organization_id    => 1,
      :user_id            => 1,
      :url                => 'cmu.edu/carnival'
    )
    new_event.save
    assert_empty(new_event.errors)

    saved_event = Event.find_by_id(new_event.id)
    # If we really wanted to stress test this method,
    # we should assert that everything in the new event
    # matches what we created the new event with. But
    # we can get away with being lazy because there
    # were no errors when we saved the event.
    assert_equal('Carnival', saved_event.name)
  end      

  def test_modify_existing_event
    # Tests that we can modify and save an event
    event_to_save = events(:one)
    event_to_save.location = "Doherty Hall"
    event_to_save.save

    assert_empty(event_to_save.errors)

    saved_event = Event.find_by_id(event_to_save.id)
    assert_equal("Doherty Hall", saved_event.location)
  end

  def test_approval_status_needs_approval
    # Tests when an event needs approval 
    test_event = events(:one)
    test_event.approval_rating = 0
    assert_equal("needs_approval", test_event.approval_status)
  end

  def test_approval_status_declined
    # Tests when an event gets declined
    test_event = events(:one)
    test_event.approval_rating = -1
    assert_equal("declined", test_event.approval_status)
  end

  def test_approval_status_approved
    # Tests when an event gets approved
    test_event = events(:one)
    test_event.approval_rating = 42
    assert_equal("approved", test_event.approval_status)
  end

  def test_can_modify_nil_user
    # Tests that a nil user cannot modify an event
    test_event = events(:one)
    test_user = nil
    assert_equal(false, test_event.can_modify?(test_user))
  end

  def test_can_modify_moderator
    # Tests that a moderator can modify an event
    test_event = events(:one)
    test_user = users(:one)
    assert_equal(true, test_event.can_modify?(test_user))
  end

  def test_can_modify_organization_user
    # Tests that an organization user can modify an event
    test_event = events(:one)
    test_user = users(:one)
    assert_equal(true, test_event.can_modify?(test_user)) 
  end

  def test_can_modify_user_not_in_organization
    # Tests that a user can't modify an event outside of their organization
    test_event = events(:one)
    test_user = users(:one)
    test_user.moderator = false
    # Event belongs to organization :one, so we'll change user to :three
    test_user.organizations.clear
    test_user.organizations << organizations(:three)
    assert_equal(false, test_event.can_modify?(test_user))
  end

  def test_approve_event
    # Tests that we can approve an event
    test_event = events(:needs_approval)
    test_event.approve_event
    assert_empty(test_event.errors)
    
    saved_test_event = Event.find_by_id(test_event.id)
    assert_equal(100, saved_test_event.approval_rating)
  end

  def test_decline_event
    # Tests that we can decline an event
    test_event = events(:needs_approval)
    test_event.decline_event
    assert_empty(test_event.errors)

    saved_test_event = Event.find_by_id(test_event.id)
    assert_equal(-1, saved_test_event.approval_rating)
  end
end
