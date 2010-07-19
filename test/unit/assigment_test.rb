require 'test_helper'

class AssigmentTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Assigment.new.valid?
  end
end
