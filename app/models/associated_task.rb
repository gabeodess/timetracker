class AssociatedTask < ActiveRecord::Base
    
  # ================
  # = Associations =
  # ================
  belongs_to :project
  belongs_to :task
  has_many :timers

  
  
  # ==============
  # = Attributes =
  # ==============
  attr_accessor :billing_rate
  
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