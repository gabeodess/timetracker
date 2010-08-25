ActionMailer::Base.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => '25',
  :domain => "timetracker.com",
  :authentication => :plain,
  :user_name => "admin@timetracker.com",
  :password => "timetrackerpassword"
}