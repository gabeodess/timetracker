class CompanyBasedRole < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :company
  belongs_to :user
  
  # ==============
  # = Attributes =
  # ==============
  cattr_accessor :names
  @@names = %w( admin employee )
  
  # ===============
  # = Validations =
  # ===============
  validates_inclusion_of :name, :in => @@names
  validates_presence_of :company_id
  validates_format_of :email, :with => String::Regex.email
  
  # =========
  # = Hooks =
  # =========
  before_save :set_user
  before_validation :set_name
  before_destroy :check_ownership
  
  def check_ownership
    !(company and company.owner_id == (User.find_by_id(user_id, :select => "id") || User.find_by_email(email, :select => 'id, email')).try(:id))
  end
  
  def set_name
    self.name ||= 'employee'
  end
  
  def set_user
    self.user = User.find_by_email(email, :select => 'id, email') if email
  end
  
  # ====================
  # = Instance Methods =
  # ====================
  def owner?
    company.owner_id == user_id
  end
  
  def user_email
    user.try(:email)
  end
  
end