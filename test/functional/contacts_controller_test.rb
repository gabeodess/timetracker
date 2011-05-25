require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  def test_index
    get :index, {}, @session_vars
    assert_template 'index'
  end
  
  def test_show
    get :show, {:id => contact}, @session_vars
    assert_template 'show'
  end
  
  def test_new
    get :new, {:contact => {:client => @client}}, @session_vars
    assert_template 'new'
  end
  
  def test_create_invalid
    Contact.any_instance.stubs(:valid?).returns(false)
    post :create, {:contact => {:client => @client}}, @session_vars
    assert_template 'new'
  end
  
  def test_create_valid
    Contact.any_instance.stubs(:valid?).returns(true)
    post :create, {:contact => {:client => @client}}, @session_vars
    assert assigns(:contact)
    assert_redirected_to client_url(assigns(:contact).client)
  end
  
  def test_edit
    get :edit, {:id => contact}, @session_vars
    assert_template 'edit'
  end
  
  def test_update_invalid
    contact
    Contact.any_instance.stubs(:valid?).returns(false)
    put :update, {:id => contact}, @session_vars
    assert_template 'edit'
  end
  
  def test_update_valid
    Contact.any_instance.stubs(:valid?).returns(true)
    put :update, {:id => contact}, @session_vars
    assert_redirected_to contact_url(assigns(:contact))
  end
  
  def test_destroy
    delete :destroy, {:id => contact}, @session_vars
    assert_redirected_to contacts_url
    assert !Contact.exists?(contact.id)
  end
  
  private
  def contact
    @contact ||= Factory(:contact, :client => @client)
  end
end
