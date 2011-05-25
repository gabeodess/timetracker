require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  
  test "should validate uniqueness of name" do
    company = Factory.build(:company, :owner_id => @company.owner_id, :name => @company.name)
    assert !company.valid?
    assert company.errors.on(:name)
  end

  test "should not validate uniqueness of name for different owner" do
    company = Factory.build(:company, :owner_id => @company.owner_id + 1, :name => @company.name)
    assert company.valid?, company.errors.full_messages
  end
  
  test "should add one company to owner on create" do
    assert_difference "@user.companies.count" do
      Factory(:company, :owner_id => @user.id)
    end
  end
  
  test "should authenticate owner" do
    CompanyBasedRole.destroy_all
    assert_not_nil Company.authenticate(@company.url_id, @user)
  end
  
  test "should authenticate associated user" do
    user = Factory(:user)
    user.companies << @company
    assert_not_nil Company.authenticate(@company.url_id, user)
  end

  test "should not authenticate random user" do
    user = Factory(:user)
    assert_nil Company.authenticate(@company.url_id, user)
  end
  
  test "should not delete company with clients" do
    assert @company.clients.count > 0
    assert_no_difference "Company.count" do
      @company.destroy
    end
  end
  
  test "should delete company with no clients" do
    @company = Factory(:empty_company)
    assert @company.reload.clients.count == 0
    assert_difference "Company.count", -1 do
      @company.destroy
    end
  end
  

end
