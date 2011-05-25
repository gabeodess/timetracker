require 'test_helper'

class CompanyBasedRolesControllerTest < ActionController::TestCase
  
  def test_index_unauthorized
    get_login_required :index
  end

  def test_index
    get_index :index, {}, @session_vars
  end
  
  def test_show_invalid
    get_login_required :show, :id => company_based_role
  end
  
  def test_show
    get_show :show, {:id => company_based_role}, @session_vars
  end
  
  def test_new_invalid
    get_login_required :new
  end
  
  def test_new
    get_new :new, {:company_based_role => {:company => @company}}, @session_vars
  end
  
  def test_create_unauthorized
    post_login_required :create
  end
  
  def test_create_invalid
    CompanyBasedRole.any_instance.stubs(:valid?).returns(false)
    post_new :create, {:company_based_role => {:company => @company}}, @session_vars
  end
  
  def test_create_valid
    CompanyBasedRole.any_instance.stubs(:valid?).returns(true)
    post :create, {:company_based_role => {:company => @company}}, @session_vars
    assert_redirected_to company_based_role_url(assigns(:company_based_role))
  end
  
  def test_edit_unauthorized
    get_login_required :edit, :id => company_based_role
  end
  
  def test_edit
    get_edit :edit, {:id => company_based_role}, @session_vars
  end
  
  def test_update_unauthorized
    put_login_required :update, :id => company_based_role
  end
  
  def test_update_invalid
    company_based_role
    CompanyBasedRole.any_instance.stubs(:valid?).returns(false)
    put_edit :update, {:id => company_based_role}, @session_vars
  end
  
  def test_update_valid
    CompanyBasedRole.any_instance.stubs(:valid?).returns(true)
    put :update, {:id => company_based_role}, @session_vars
    assert_redirected_to company_based_role_url(assigns(:company_based_role))
  end
  
  def test_destroy_unauthorized
    delete_login_required :destroy, :id => company_based_role
    assert CompanyBasedRole.exists?(company_based_role.id)
  end
  
  def test_destroy
    cbr = Factory(:company_based_role, :company => @company, :user => Factory(:user))
    delete :destroy, {:id => cbr.id}, @session_vars
    assert_redirected_to :company_based_roles
    assert !CompanyBasedRole.exists?(cbr.id)
  end
  
  private
  def company_based_role
    @company_based_role ||= Factory(:company_based_role, :company => @company, :user => @user)
  end
  
end
