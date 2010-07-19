require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Client.new.valid?
  end
end
