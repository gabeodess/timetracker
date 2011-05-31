require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase

  test "should not update total through mass assignment" do
    company = Factory(:company)
    invoice = Factory(:invoice, :client => company.clients.first)
    assert invoice.update_attribute(:total, 10)
    assert invoice.total == 10
    assert invoice.update_attributes!(:total => 20)
    assert invoice.total == 10
  end
  
  test "after print receipt total should equal tally_total and tally_total_from_receipt" do
    company = Factory(:company)
    client = company.clients.first
        
    10.times{ |i| Factory(:timer, {:user => company.owner, :associated_task => client.projects.sample.associated_tasks.sample}) }
    10.times{ |i| Factory(:expense, :project_id => client.project_ids.sample) }
    
    invoice = Factory(:invoice, {
      :client => client, 
      :timers => client.uninvoiced_timers, 
      :expenses => client.uninvoiced_expenses
    })

    assert invoice.timers.count == 10, invoice.timers.count.inspect
    assert invoice.timers_cost > 0
    assert invoice.expenses.count == 10
    assert invoice.expenses_cost > 0, invoice.expenses.map(&:cost)
    assert client.uninvoiced_timers.empty?
    
    invoice.print_receipt
    invoice.save!
    
    invoice = Invoice.find(invoice.id)
    
    assert invoice.timers.count == 10, invoice.timers.count.inspect
    assert invoice.timers_cost > 0
    assert invoice.expenses.count == 10
    assert invoice.expenses_cost > 0, invoice.expenses.map(&:cost)
    assert client.uninvoiced_timers.empty?
    
    assert (invoice.total - invoice.tally_total).abs < 0.001, [invoice.total, invoice.tally_total].inspect
    assert_not_nil invoice.tally_timer_total_from_receipt
    assert_not_nil invoice.tally_expense_total_from_receipt
    assert (invoice.total - invoice.tally_total_from_receipt).abs < 0.001, [invoice.total, invoice.tally_total_from_receipt].inspect
    
  end

end
