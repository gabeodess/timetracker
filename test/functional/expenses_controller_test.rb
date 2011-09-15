require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  
  def test_show_invalid
    get_login_required :show, :id => expense
  end
  
  def test_show
    get_show :show, {:id => expense}, @session_vars
  end
  
  def test_new_invalid
    get_login_required :new
  end
  
  def test_new
    get_new :new, {:expense => {:project_id => @project.id}}, @session_vars
  end
  
  def test_create_unauthorized
    post_login_required :create
  end
  
  def test_create_invalid
    Expense.any_instance.stubs(:valid?).returns(false)
    post_new :create, {:expense => {:project => @project}}, @session_vars
  end
  
  def test_create_valid
    Expense.any_instance.stubs(:valid?).returns(true)
    post :create, {:expense => Factory.build(:expense, :project => @project).attributes}, @session_vars
    assert_redirected_to project_url(assigns(:expense).project_id)
  end
  
  def test_edit_unauthorized
    get_login_required :edit, :id => expense
  end
  
  def test_edit
    get_edit :edit, {:id => expense}, @session_vars
  end
  
  def test_update_unauthorized
    put_login_required :update, :id => expense
  end
  
  def test_update_invalid
    @expense = expense
    Expense.any_instance.stubs(:valid?).returns(false)
    put_edit :update, {:id => @expense}, @session_vars
  end
  
  def test_update_valid
    Expense.any_instance.stubs(:valid?).returns(true)
    put :update, {:id => expense}, @session_vars
    assert_redirected_to project_url(assigns(:expense).project)
  end
  
  def test_destroy_unauthorized
    delete_login_required :destroy, {:id => expense.id}
    assert Expense.exists?(expense.id)
  end
  
  def test_destroy
    delete :destroy, {:id => expense.to_param}, @session_vars
    assert_redirected_to project_url(assigns(:expense).project)
    assert !Expense.exists?(expense.id)
  end
  
  private
  def expense
    @expense ||= Factory(:expense, :project => @project)
  end
  
end
