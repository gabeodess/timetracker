class CompanyBasedRole < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :company
  belongs_to :user#, :foreign_key => :email, :primary_key => :email
  
  # ==============
  # = Attributes =
  # ==============
  
  # ===============
  # = Validations =
  # ===============
  validates_inclusion_of :name, :in => %w( admin employee )
  validates_presence_of :user_id, :company_id
  
  # =========
  # = Hooks =
  # =========
  before_validation :set_name
  before_destroy :check_ownership
  
  def check_ownership
    !(company and company.owner_id == user.id)
  end
  
  def set_name
    self.name ||= 'employee'
  end
  
  # ====================
  # = Instance Methods =
  # ====================
  def owner?
    company.owner_id == user_id
  end
  
  def user_email
    user.email
  end
  
end