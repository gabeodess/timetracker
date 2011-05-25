require 'test_helper'

class MailerTest < ActionMailer::TestCase
  test "invoice" do
    invoice = Factory(:invoice, :client => @client)

    @expected.subject = "#{Rails.env unless Rails.env.production?}Invoice #{invoice.id} From #{invoice.company.name}"
    @expected.body    = read_fixture('invoice')
    @expected.date    = Time.now
    
    email = Mailer.create_invoice(invoice)
    assert_equal @expected.subject, email.subject
  end

end
