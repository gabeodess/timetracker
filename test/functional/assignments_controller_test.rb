require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Assignment.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Assignment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Assignment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to assignment_url(assigns(:assignment))
  end
  
  def test_edit
    get :edit, :id => Assignment.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Assignment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Assignment.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Assignment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Assignment.first
    assert_redirected_to assignment_url(assigns(:assignment))
  end
  
  def test_destroy
    assignment = Assignment.first
    delete :destroy, :id => assignment
    assert_redirected_to assignments_url
    assert !Assignment.exists?(assignment.id)
  end
end
