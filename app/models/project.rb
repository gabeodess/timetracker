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

  has_many :uninvoiced_timers, :through => :associated_tasks, :source => :timers, :conditions => "timers.invoice_id is null"
  has_many :expenses, :dependent => :destroy
  has_many :uninvoiced_expenses, :class_name => "Expense", :conditions => "expenses.invoice_id is null"
  
  def company
    client.company
  end
  
  # ==============
  # = Attributes =
  # ==============
  cattr_reader :billing_options
  @@billing_options = {
    :user => "Bill By User",
    :project => "Bill By Project",
    :non_billable => "Non-Billable"
  }
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :name, :client
  validates_inclusion_of :billing, :in => @@billing_options.keys.map(&:to_s), :message => ": Please select a valid billing option"
  validates_presence_of :billing_rate, :if => Proc.new{ |project| project.billing == 'project' }
  
  # =========
  # = Hooks =
  # =========
  after_create :add_to_users
  before_destroy :destroy_worthy?
  
  def destroy_worthy?
    timers.first(:select => 'timers.id').nil?
  end
  
  def add_to_users
    users.each do |user|
      user.projects << self
    end
  end
  
  # ====================
  # = Instance Methods =
  # ====================
  def billing_project?
    billing == 'project'
  end
  
  def uninvoiced_timer_cost
    uninvoiced_timers.map{ |timer| timer.cost }.sum
  end
  
  def uninvoiced_expense_cost
    uninvoiced_expenses.map{ |expense| expense.cost }.sum
  end
  
  def uninvoiced_cost
    uninvoiced_timer_cost + uninvoiced_expense_cost
  end
  
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