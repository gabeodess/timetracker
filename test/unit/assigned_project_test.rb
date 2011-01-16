require 'test_helper'

class AssignedProjectTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert AssignedProject.new.valid?
  end
end
