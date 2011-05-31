require 'test_helper'

class CompanyBasedRoleTest < ActiveSupport::TestCase
  
  test "should not delete owner role" do
    assert_no_difference "@user.company_based_roles.count" do
      @user.company_based_roles.each(&:destroy)
    end
  end
  
end
