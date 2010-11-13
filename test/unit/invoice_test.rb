require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase

  test "should not update total through mass assignment" do
    invoice = Factory(:invoice, :total => 10)
    assert invoice.update_attribute(:total, 10)
    assert invoice.total == 10
    assert invoice.update_attributes!(:total => 20)
    assert invoice.total == 10
  end
  
  test "after print receipt total should equal tally_total and tally_total_from_receipt" do
    invoice = Factory(:invoice)
    client = invoice.client
    company = client.company
    
    10.times{ |i| client.projects << Factory.build(:project, :tasks => company.tasks) }
    client.save!
    assert client.projects.length == 10, client.projects.length.inspect
    assert client.projects.count == 10, client.projects.count.inspect
    assert client.projects.map{ |p| p.tasks.empty? }.uniq == [false]
    
    10.times{ |i| Factory(:timer, :associated_task => client.projects.random_element.associated_tasks.random_element) }
    10.times{ |i| Factory(:expense, :project_id => client.project_ids.random_element) }
    
    invoice.timers = client.uninvoiced_timers
    invoice.expenses = client.uninvoiced_expenses
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
