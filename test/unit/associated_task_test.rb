require 'test_helper'

class AssociatedTaskTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert AssociatedTask.new.valid?
  end
end
