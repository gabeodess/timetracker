require 'test_helper'

class BillingRateTest < ActionController::IntegrationTest

  def setup
    @company = Factory(:company)
    @user = @company.owner
    @project = @company.projects.first
    @timer = Factory(:timer, {
      :user => @user, 
      :associated_task => @project.associated_tasks.random_element, 
      :total_time => 3600
    })
  end
  
  test "should select billing rate based on project billing" do
    @user.update_attributes!({:billing_rate => 60})
    
    # =====================
    # = Test Bill By User =
    # =====================
    @project.update_attributes!({:billing => 'user', :billing_rate => 100})
    assert @timer.billing_rate == 60
    
    invoice = Factory(:invoice, {:timers => [@timer], :client => @project.client})
    assert invoice.total == 60
    assert invoice.tally_total == 60
    assert invoice.tally_total_from_receipt == 60
    assert invoice.load_info[:projects][@project.name][:timers_total] == 60
    
    # ===================
    # = Bill By Project =
    # ===================
    @project.update_attributes!({:billing => 'project'})
    assert @timer.reload.billing_rate == 100
    
    assert invoice.total == 60
    assert invoice.tally_total == 100
    assert invoice.tally_total_from_receipt == 60
    assert invoice.load_info[:projects][@project.name][:timers_total] == 60
    
    invoice.print_receipt
    assert invoice.total == 100
    assert invoice.tally_total == 100
    assert invoice.tally_total_from_receipt == 100
    assert invoice.load_info[:projects][@project.name][:timers_total] == 100
    
    # ================
    # = Non-Billable =
    # ================
    @project.update_attributes!({:billing => 'non_billable'})
    assert @timer.reload.billing_rate == 0

    assert invoice.total == 100
    assert invoice.tally_total == 0
    assert invoice.tally_total_from_receipt == 100
    assert invoice.load_info[:projects][@project.name][:timers_total] == 100
    
    invoice.print_receipt
    assert invoice.total == 0
    assert invoice.tally_total == 0
    assert invoice.tally_total_from_receipt == 0
    assert invoice.load_info[:projects][@project.name][:timers_total] == 0
    
  end

end
