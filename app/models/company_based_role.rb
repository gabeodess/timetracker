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
  
end