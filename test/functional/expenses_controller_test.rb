require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Expense.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Expense.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Expense.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to expense_url(assigns(:expense))
  end
  
  def test_edit
    get :edit, :id => Expense.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Expense.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Expense.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Expense.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Expense.first
    assert_redirected_to expense_url(assigns(:expense))
  end
  
  def test_destroy
    expense = Expense.first
    delete :destroy, :id => expense
    assert_redirected_to expenses_url
    assert !Expense.exists?(expense.id)
  end
end
