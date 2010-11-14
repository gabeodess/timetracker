require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  
  # ========
  # = Edit =
  # ========
  test "should display proper options for billing select on edit" do
    get :edit, {:id => @project.id}, @session_vars
    assert_response :ok
    assert assigns(:project)
    assert_template 'edit'
  end
  
end
