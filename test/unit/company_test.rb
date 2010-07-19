require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Company.new.valid?
  end
end
