class Project < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :client
  has_many :associated_tasks, :dependent => :destroy
  accepts_nested_attributes_for(
    :associated_tasks, 
    :allow_destroy => true, 
    :reject_if => proc { |obj| puts obj['_destroy'] == "1"; obj.delete('_destroy') == "1" }
  )
  
  has_many :timers, :through => :associated_tasks
  has_many :tasks, :through => :associated_tasks
  has_many :assigned_projects, :dependent => :destroy
  has_many :users, :through => :assigned_projects
  has_many :expenses, :dependent => :destroy
  
  def uninvoiced_timers
    timers.invoice_id_is(nil)
  end
  def company
    client.company
  end
  
  # ==============
  # = Attributes =
  # ==============
  attr_accessor :billing
  
  # =========
  # = Hooks =
  # =========
  after_create :add_to_users
  
  def add_to_users
    users.each do |user|
      user.projects << self
    end
  end
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :name
  validates_presence_of :client_id
  
  
  # ====================
  # = Instance Methods =
  # ====================  
  def uninvoiced_hours
    @uninvoiced_hour ||= uninvoiced_timers.map(&:hours).sum
  end
  
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