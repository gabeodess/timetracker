require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Invoice.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Invoice.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Invoice.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to invoice_url(assigns(:invoice))
  end
  
  def test_edit
    get :edit, :id => Invoice.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Invoice.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Invoice.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Invoice.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Invoice.first
    assert_redirected_to invoice_url(assigns(:invoice))
  end
  
  def test_destroy
    invoice = Invoice.first
    delete :destroy, :id => invoice
    assert_redirected_to invoices_url
    assert !Invoice.exists?(invoice.id)
  end
end
