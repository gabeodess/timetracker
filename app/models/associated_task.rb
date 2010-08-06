class AssociatedTask < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :project
  belongs_to :task
  has_many :assignments

  
  
  # ==============
  # = Attributes =
  # ==============
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :project
  validates_presence_of :task
  
  # ====================
  # = Instance Methods =
  # ====================
  def name
    task.name
  end
  
end