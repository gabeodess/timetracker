class Validator
  cattr_accessor :login_regex, :bad_login_message, 
    :name_regex, :bad_name_message, :zip_code_regex,
    :email_name_regex, :domain_head_regex, :domain_tld_regex, :email_regex, :bad_email_message, :currency_regex

  self.login_regex       = /\A\w[\w\.\-_@]+\z/                     # ASCII, strict
  # self.login_regex       = /\A[[:alnum:]][[:alnum:]\.\-_@]+\z/     # Unicode, strict
  # self.login_regex       = /\A[^[:cntrl:]\\<>\/&]*\z/              # Unicode, permissive

  self.bad_login_message = "use only letters, numbers, and .-_@ please.".freeze

  self.name_regex        = /\A[^[:cntrl:]\\<>\/&]*\z/              # Unicode, permissive
  self.bad_name_message  = "avoid non-printing characters and \\&gt;&lt;&amp;/ please.".freeze

  self.email_name_regex  = '[\w\.%\+\-]+'.freeze
  self.domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  self.domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
  self.email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  self.bad_email_message = "should look like an email address.".freeze
  
  self.zip_code_regex = /^\d{5}([\-]\d{4})?$/
  self.currency_regex = /^\$[\d,]+$|^\$[\d,]+\.\d$|^\$\.\d+$|^[\d,]+$|^[\d,]+\.\d+$|^\.\d+$/
  
end
