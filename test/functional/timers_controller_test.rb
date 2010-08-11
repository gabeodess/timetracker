require 'test_helper'

class TimersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Timer.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Timer.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Timer.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to timer_url(assigns(:timer))
  end
  
  def test_edit
    get :edit, :id => Timer.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Timer.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Timer.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Timer.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Timer.first
    assert_redirected_to timer_url(assigns(:timer))
  end
  
  def test_destroy
    timer = Timer.first
    delete :destroy, :id => timer
    assert_redirected_to timers_url
    assert !Timer.exists?(timer.id)
  end
end
