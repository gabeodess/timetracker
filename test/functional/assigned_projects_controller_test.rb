require 'test_helper'

class AssignedProjectsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => AssignedProject.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    AssignedProject.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    AssignedProject.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to assigned_project_url(assigns(:assigned_project))
  end
  
  def test_edit
    get :edit, :id => AssignedProject.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    AssignedProject.any_instance.stubs(:valid?).returns(false)
    put :update, :id => AssignedProject.first
    assert_template 'edit'
  end
  
  def test_update_valid
    AssignedProject.any_instance.stubs(:valid?).returns(true)
    put :update, :id => AssignedProject.first
    assert_redirected_to assigned_project_url(assigns(:assigned_project))
  end
  
  def test_destroy
    assigned_project = AssignedProject.first
    delete :destroy, :id => assigned_project
    assert_redirected_to assigned_projects_url
    assert !AssignedProject.exists?(assigned_project.id)
  end
end
