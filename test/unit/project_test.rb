require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  def setup
    company = Factory(:company)
    @project = company.clients.first.projects.first
  end
  
  # ===========
  # = Billing =
  # ===========
  test "should set project billing rate" do
    @project.update_attributes!({:billing => 'project', :billing_rate => 0})
    assert Project.find(@project.id).billing == 'project'
  end
  
  test "should validate presence of billing rate if billing is project" do
    assert !@project.update_attributes({:billing => 'project', :billing_rate => nil})
  end
  
  test "should validate inclusion of billing rate" do
    assert !@project.update_attributes({:billing => 'foo'})
  end
  
  test "should require billing" do
    assert !@project.update_attributes({:billing => nil})
  end

end
