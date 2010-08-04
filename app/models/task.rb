class Task < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :company
  has_many :associated_tasks
  has_many :assignments, :through => :associated_tasks

  
  
  # ==============
  # = Attributes =
  # ==============
  
  # ===============
  # = Validations =
  # ===============
  
  
end