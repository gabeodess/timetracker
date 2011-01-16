require 'test_helper'

class AssociatedTasksControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => AssociatedTask.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    AssociatedTask.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    AssociatedTask.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to associated_task_url(assigns(:associated_task))
  end
  
  def test_edit
    get :edit, :id => AssociatedTask.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    AssociatedTask.any_instance.stubs(:valid?).returns(false)
    put :update, :id => AssociatedTask.first
    assert_template 'edit'
  end
  
  def test_update_valid
    AssociatedTask.any_instance.stubs(:valid?).returns(true)
    put :update, :id => AssociatedTask.first
    assert_redirected_to associated_task_url(assigns(:associated_task))
  end
  
  def test_destroy
    associated_task = AssociatedTask.first
    delete :destroy, :id => associated_task
    assert_redirected_to associated_tasks_url
    assert !AssociatedTask.exists?(associated_task.id)
  end
end
