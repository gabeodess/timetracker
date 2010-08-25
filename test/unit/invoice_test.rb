require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Invoice.new.valid?
  end
end
