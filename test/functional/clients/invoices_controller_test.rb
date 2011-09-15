require 'test_helper'

class Clients::InvoicesControllerTest < ActionController::TestCase
  
  test "get index with valid user" do
    assert @client.company.users.include?(@user)
    get_index :index, {:client_id => @client}, @session_vars
  end
  
  test "get index with invalid user" do
    user = Factory(:user)
    company = Factory(:company, :owner => user)
    get_permission_denied :index, {:client_id => @client}, {:user_id => user, :company_id => company.to_param}
  end
  
  test "get index with guest" do
    get_login_required :index, {:client_id => @client}
  end
  
end