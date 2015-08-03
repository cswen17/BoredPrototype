require 'test_helper'

class OrganizationsTest < ActiveSupport::TestCase

    fixtures :organizations
    def test_validates_presence_of_name
      # Asserts that we can't save an organization without a name
      nameless_org = Organization.new(
        :url => 'www.ihavenonamebutihaveaurl.com'
      )
      nameless_org.save

      assert_equal ["can't be blank"], nameless_org.errors.messages[:name]
    end

    def test_validates_uniqueness_of_name
      # Asserts that we can't save an organization with an existing name
      org = organizations(:one)
      same_name_org = Organization.new(
        :name => org.name,
        :url => 'www.somefakeurl.com'
      )
      same_name_org.save

      assert_equal ["has already been taken"], same_name_org.errors.messages[:name]
    end

    def test_scope_for_user
    end

end
