class Assignment < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :task
  belongs_to :user

  
  
  # ==============
  # = Attributes =
  # ==============
  
  # ===============
  # = Validations =
  # ===============
  
  
end