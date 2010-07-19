require 'test_helper'

class AssigmentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Assigment.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Assigment.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Assigment.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to assigment_url(assigns(:assigment))
  end
  
  def test_edit
    get :edit, :id => Assigment.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Assigment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Assigment.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Assigment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Assigment.first
    assert_redirected_to assigment_url(assigns(:assigment))
  end
  
  def test_destroy
    assigment = Assigment.first
    delete :destroy, :id => assigment
    assert_redirected_to assigments_url
    assert !Assigment.exists?(assigment.id)
  end
end
