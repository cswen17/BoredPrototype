require 'test_helper'

class UsersTest < ActiveSupport::TestCase

  fixtures :users
  fixtures :organizations
  fixtures :organization_users

  def test_can_moderate_moderator
    user = users(:one)
    assert_equal true, user.can_moderate?
  end

  def test_can_moderate_no_moderator
    user = users(:two)
    assert_equal false, user.can_moderate?
  end

  def test_name
    user = users(:one)
    assert_equal 'Joe User', user.name
  end

  def test_organizations_string
    user = users(:one)
    assert_equal 'ACM,Activities Board', user.organizations_string
  end
end
