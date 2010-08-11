class Project < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :client
  has_many :associated_tasks, :dependent => :destroy
  has_many :timers, :through => :associated_tasks
  has_many :tasks, :through => :associated_tasks
  has_many :assigned_projects, :dependent => :destroy
  has_many :users, :through => :assigned_projects
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :client_id
  
  # =========
  # = Hooks =
  # =========
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :name
  validates_presence_of :client_id
  
  
  # ====================
  # = Instance Methods =
  # ====================
  def total_time
    timers.map{ |item| item.total_time }.sum
  end
  
  def hours_worked
    (total_time.to_f/3600)
  end
  
  def percent_of_allotted_hours_used
    allotted_hours.to_f > 0 ? (hours_worked.to_f/allotted_hours*100) : 100.0
  end
  
end