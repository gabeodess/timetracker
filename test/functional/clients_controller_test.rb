require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Client.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Client.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Client.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to client_url(assigns(:client))
  end
  
  def test_edit
    get :edit, :id => Client.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Client.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Client.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Client.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Client.first
    assert_redirected_to client_url(assigns(:client))
  end
  
  def test_destroy
    client = Client.first
    delete :destroy, :id => client
    assert_redirected_to clients_url
    assert !Client.exists?(client.id)
  end
end
