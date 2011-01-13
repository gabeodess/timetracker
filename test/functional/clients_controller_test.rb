require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  
  # ========
  # = Show =
  # ========
  test "should get show page" do
    get :show, {:id => @client.id}, @session_vars
    assert_response :ok
    assert assigns(:client)
    assert_template 'show'
  end
  
end
