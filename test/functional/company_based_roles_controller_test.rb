require 'test_helper'

class CompanyBasedRolesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => CompanyBasedRole.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    CompanyBasedRole.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    CompanyBasedRole.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to company_based_role_url(assigns(:company_based_role))
  end
  
  def test_edit
    get :edit, :id => CompanyBasedRole.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    CompanyBasedRole.any_instance.stubs(:valid?).returns(false)
    put :update, :id => CompanyBasedRole.first
    assert_template 'edit'
  end
  
  def test_update_valid
    CompanyBasedRole.any_instance.stubs(:valid?).returns(true)
    put :update, :id => CompanyBasedRole.first
    assert_redirected_to company_based_role_url(assigns(:company_based_role))
  end
  
  def test_destroy
    company_based_role = CompanyBasedRole.first
    delete :destroy, :id => company_based_role
    assert_redirected_to company_based_roles_url
    assert !CompanyBasedRole.exists?(company_based_role.id)
  end
end
