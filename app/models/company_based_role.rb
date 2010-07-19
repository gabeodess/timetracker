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
  
  
end