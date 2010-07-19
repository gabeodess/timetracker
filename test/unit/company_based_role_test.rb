require 'test_helper'

class CompanyBasedRoleTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert CompanyBasedRole.new.valid?
  end
end
