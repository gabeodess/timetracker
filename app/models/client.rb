class Client < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  has_many :projects, :dependent => :destroy
  has_many :expenses, :through => :projects
  has_many :associated_tasks, :through => :projects
  has_many :tasks, :through => :projects
  has_many :contacts, :dependent => :destroy
  has_many :invoices
  has_many :unpaid_invoices, {
    :class_name => "Invoice", 
    :foreign_key => "client_id", 
    :conditions => "abs(invoices.total - invoices.amount_paid) > 0.001"
  }
  belongs_to :company
  def expenses
    Expense.project_id_is_any(project_ids)
  end
  def uninvoiced_expenses
    expenses.invoice_id_is(nil)
  end
  def timer_ids
    associated_tasks.map(&:timers).flatten.map(&:id)
  end
  def timers
    # => The Searchlogic *any* option returns everything as apposed to nothing when handed an empty array.
    # Therefor, we include "0" so that if timer_ids is empty it will look for a timer with id of 0 and find nothing.
    Timer.id_is_any(timer_ids << 0) 
  end
  def uninvoiced_timers
    timers.invoice_id_is(nil)
  end 
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :company_id
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :name
  validates_presence_of :company_id
  
  # =========
  # = Hooks =
  # =========
  before_destroy :destroy_worthy?
  
  def destroy_worthy?
    [invoices.first(:select => 'id'), projects.first(:select => 'id')].uniq == [nil]
  end
  
  # ====================
  # = Instance Methods =
  # ====================  
  def uninvoiced_hours
    @uninvoiced_hours ||= uninvoiced_timers.map(&:hours).sum
  end
  
  def uninvoiced_balance
    uninvoiced_timers.map{ |item| item.hours.to_f * item.billing_rate.to_f }.sum
  end
  
  def total_time
    @total_time ||= timers.map(&:total_time).sum
  end
  
  def hours
    @hours ||= timers.map(&:hours).map(&:to_f).sum
  end
    
  def total_due
    @total_due ||= timers.map{ |item| item.hours.to_f * item.billing_rate.to_f }.sum
  end
  
  def total_paid
    @total_paid ||= invoices.map(&:amount_paid).map(&:to_f).sum
  end
  
  def outstanding_balance
    @outstanding_balance ||= total_due - total_paid
  end
  
end