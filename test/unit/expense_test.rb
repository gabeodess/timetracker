require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Expense.new.valid?
  end
end
