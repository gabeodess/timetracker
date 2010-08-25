class Contact < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :client

  
  
  # ==============
  # = Attributes =
  # ==============
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :email
  validates_format_of :email, :with => Validator.email_regex
  
  # ====================
  # = Instance Methods =
  # ====================
  def full_name
    [first_name, last_name].join(" ")
  end
  def info
    [last_name, first_name, email, phone].join(', ')
  end
  
end