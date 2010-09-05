class Client < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  has_many :projects, :dependent => :destroy
  has_many :associated_tasks, :through => :projects
  has_many :tasks, :through => :projects
  has_many :contacts, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  belongs_to :company
  
  def timer_ids
    associated_tasks.map(&:timers).flatten.map(&:id)
  end
  def timers
    return timer_ids.empty? ? [] : Timer.id_is_any(timer_ids) 
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
  
  # ====================
  # = Instance Methods =
  # ====================
  def total_time
    @total_time ||= timers.map(&:total_time).sum
  end
  
  def hours
    @hours ||= timers.map(&:hours).map(&:to_f).sum
  end
    
  def total_due
    @total_due ||= timers.map{ |item| item.hours.to_f * item.user.billing_rate.to_f }.sum
  end
  
  def total_paid
    @total_paid ||= invoices.map(&:amount_paid).map(&:to_f).sum
  end
  
  def outstanding_balance
    @outstanding_balance ||= total_due - total_paid
  end
  
end