require 'test_helper'

class MailerTest < ActionMailer::TestCase
  test "invoice" do
    @expected.subject = 'Mailer#invoice'
    @expected.body    = read_fixture('invoice')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Mailer.create_invoice(@expected.date).encoded
  end

end
