require 'test_helper'

class TimerTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Timer.new.valid?
  end
end
