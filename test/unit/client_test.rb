require 'test_helper'

class ClientTest < ActiveSupport::TestCase

  test "should get unpaid invoices" do
    company = Factory(:company)
    client = company.clients.first
    
    5.times do |i|
      5.times do |i|
        Factory(:timer, {
          :user => company.owner,
          :associated_task => client.projects.map(&:associated_tasks).flatten.random_element
        })
        Factory(:expense, :project => client.projects.random_element)
      end
      Factory(:invoice, {
        :timers => client.timers,
        :expenses => client.expenses,
        :client => client
      })
    end
    
    assert (invoice_count = client.invoices.count) > 0
    assert client.unpaid_invoices.count > 0, "there are no unpaid invoices"
    assert client.unpaid_invoices.count == invoice_count, client.invoices.map{ |item| [item.total, item.amount_paid] }.inspect
  end

end
