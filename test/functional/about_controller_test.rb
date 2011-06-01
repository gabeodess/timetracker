require 'test_helper'

class AboutControllerTest < ActionController::TestCase
  test "should get index" do
    get_index :index
    assert_layout 'layout/info'
  end
end
