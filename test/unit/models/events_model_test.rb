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

  def test_option_nil_event_start
    # Tests that event with no start returns closest half hour
    new_event = Event.new
    new_event.event_start = nil
    later = Time.now + (60 * 30)
    now_hr, now_min = [later.strftime('%H'), later.strftime('%M')]
    if (now_min.to_i >= 45)
      expected_half_hour = "#{(now_hr.to_i + 1) % 24}:00"
    elsif (now_min.to_i >= 30)
      expected_half_hour = "#{now_hr}:30"
    elsif (now_min.to_i >= 15)
      expected_half_hour = "#{now_hr}:30"
    else
      expected_half_hour = "#{now_hr}:00"
    end
    assert_equal(expected_half_hour, new_event.option_event_start)
  end

  def test_option_valid_event_start
    # Tests that option for event start returns event's start time
    test_event = events(:one)
    expected_event_start = test_event.event_start.strftime('%H:%M')
    assert_equal(expected_event_start, test_event.option_event_start)
  end

  def test_option_nil_event_end
    # Tests that event with no end returns closest 1.5 hour
    new_event = Event.new
    later = Time.now + (60 * 90)
    later_hr, later_min = [later.strftime('%H'), later.strftime('%M')]
    if (later_min.to_i >= 45) 
      expected_half_hour = "#{(later_hr.to_i + 1) % 24}:00"
    elsif (later_min.to_i >= 30)
      expected_half_hour = "#{later_hr}:30"
    elsif (later_min.to_i >= 15)
      expected_half_hour = "#{later_hr}:30"
    else
      expected_half_hour = "#{later_hr}:00"
    end
    assert_equal(expected_half_hour, new_event.option_event_end)
  end

  def test_option_valid_event_end
    # Tests that option for event end returns event's end time
    test_event = events(:one)
    expected_event_end = test_event.event_end.strftime('%H:%M')
    assert_equal(expected_event_end, test_event.option_event_end)
  end

  def test_edit_nil_event_start
    # Tests that text edit for event start defaults to today's date
    new_event = Event.new
    expected_event_start = Time.now.strftime('%m/%d/%Y')
    assert_equal(expected_event_start, new_event.edit_event_start)
  end

  def test_edit_valid_event_start
    # Tests that text edit for event start defaults to event's start date
    test_event = events(:one)
    expected_event_start = test_event.event_start.strftime('%m/%d/%Y')
    assert_equal(expected_event_start, test_event.edit_event_start)
  end

  def test_edit_nil_event_end
    # Tests that text edit for event end defaults to today's date
    new_event = Event.new
    expected_event_end = Time.now.strftime('%m/%d/%Y')
    assert_equal(expected_event_end, new_event.edit_event_end)
  end

  def test_edit_valid_event_end
    # Tests that text edit for event end defaults to event's end date
    test_event = events(:one)
    expected_event_end = test_event.event_end.strftime('%m/%d/%Y')
    assert_equal(expected_event_end, test_event.edit_event_end)
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
