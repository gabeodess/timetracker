class Mailer < ActionMailer::Base
  

  def invoice(invoice)
    subject    "#{Rails.env unless Rails.env.production?}Invoice #{invoice.id} From #{invoice.company.name}"
    recipients invoice.invoice_emails
    from       '"Time Tracker" <notify@timetracker.com>'
    sent_on    Time.now
    
    body       :invoice => invoice
    content_type "text/html"
  end

end
