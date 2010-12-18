require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  
  # =========
  # = Index =
  # =========
  test "should require login on index" do
    get_login_required :index
  end
  
  # ========
  # = Show =
  # ========
  test "should get show page" do
    get_show :show, {:id => @invoice}, @session_vars
  end
  
  # =======
  # = New =
  # =======
  test "should require login on new" do
    get_login_required :new
  end
  
  test "should get new with user" do
    get_new :new, {:invoice => {:client => @client}}, @session_vars
  end
  
  test "should get new with no timers" do
    Timer.destroy_all
    assert @client.reload.timer_ids.empty?
    get_new :new, {:invoice => {:client => @client}}, @session_vars
  end
  
  test "should require client on new" do
    get :new, {}, @session_vars
    assert_response 403
  end
  
end
