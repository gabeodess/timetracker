require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Assignment.new.valid?
  end
end
