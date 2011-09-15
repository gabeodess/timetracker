require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "get index as mobile" do
    get_index :index, {:format => :mobile}
  end
end
