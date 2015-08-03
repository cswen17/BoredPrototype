require 'test_helper'

class OrganizationUsersTest < ActiveSupport::TestCase

  def test_save_organization_user
    # Assert that we can create an organization user join relation
    org_user = OrganizationUser.new(
      :organization_id => 3,
      :user_id => 1
    )
    org_user.save

    assert_empty org_user.errors
  end
end
