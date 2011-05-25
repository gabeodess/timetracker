require 'test_helper'

class AssociatedTasksControllerTest < ActionController::TestCase
  def test_index_unauthorized
    get_login_required :index, {:project_id => @project.id}
  end

  def test_index
    get_index :index, {:project_id => @project.id}, @session_vars
  end
  
end
