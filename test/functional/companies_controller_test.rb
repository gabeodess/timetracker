require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  def test_index_unauthorized
    get_login_required :index
  end

  def test_index
    get_index :index, {}, @session_vars
  end
  
  def test_show_invalid
    get_login_required :show, :id => @company
  end
  
  def test_show
    get_show :show, {:id => @company.to_param}, @session_vars
  end
  
  def test_new_invalid
    get_login_required :new
  end
  
  def test_new
    get_new :new, {:company => {:owner_id => @user.id}}, @session_vars
  end
  
  def test_create_unauthorized
    post_login_required :create
  end
  
  def test_create_invalid
    Company.any_instance.stubs(:valid?).returns(false)
    post_new :create, {}, @session_vars
  end
  
  def test_create_valid
    Company.any_instance.stubs(:valid?).returns(true)
    post :create, {}, @session_vars
    assert_redirected_to assigns(:company).owner
  end
  
  def test_edit_unauthorized
    get_login_required :edit, :id => @company.to_param
  end
  
  def test_edit
    get_edit :edit, {:id => @company.to_param}, @session_vars
  end
  
  def test_update_unauthorized
    put_login_required :update, :id => @company.to_param
  end
  
  def test_update_invalid
    Company.any_instance.stubs(:valid?).returns(false)
    put_edit :update, {:id => @company.to_param}, @session_vars
  end
  
  def test_update_valid
    Company.any_instance.stubs(:valid?).returns(true)
    put :update, {:id => @company.to_param}, @session_vars
    assert_redirected_to :dashboard
  end
  
  def test_destroy_unauthorized
    company = @company
    delete_login_required :destroy, :id => company
    assert Company.exists?(company.id)
  end
  
  def test_destroy
    company = Factory(:empty_company, :owner => @user)
    delete :destroy, {:id => company.to_param}, @session_vars
    assert_redirected_to @user
    assert !Company.exists?(company.id)
  end
  
end
