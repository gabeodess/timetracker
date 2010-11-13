class Invoice < ActiveRecord::Base
  
  def after_initialize
    self.invoice_emails ||= []    
  end
  
  # ==========
  # = Scopes =
  # ==========
  default_scope :order => "created_at ASC"
  
  # ================
  # = Associations =
  # ================
  belongs_to :client
  has_many :timers
  has_many :expenses
  def projects
    client.projects
  end
  def uninvoiced_timers
    client ? client.timers.all(:conditions => "invoice_id is null and timer_started_at is null") : []
  end
  def invoiced_timers
    client ? client.timers.invoice_id_gt(0) : []
  end
  def uninvoiced_expenses
    client.uninvoiced_expenses
  end
  def contacts
    client.contacts
  end
  def company
    client.company
  end
  
  # ==============
  # = Attributes =
  # ==============
  attr_accessor :invoice_emails, :email_ids, :email_me
  attr_protected :info, :invoice_emails, :timer_ids, :expense_ids, :total
  
  def issued_at
    created_at.to_date unless new_record?
  end
  
  def work_period_start
    # => I use sort_by instead of ordering on the database level here because when you create a new Invoice the 
    # timers are not stored in the database yet, only in the cache.  Besides there are so few timers associated
    # with each invoice that we don't see a load hit.
    timers.select{ |item| item.created_at }.sort_by(&:created_at).first.try(:created_at)
  end
  
  def work_period_end
    # => I use sort_by instead of ordering on the database level here because when you create a new Invoice the 
    # timers are not stored in the database yet, only in the cache.  Besides there are so few timers associated
    # with each invoice that we don't see a load hit.
    timers.select{ |item| item.stopped_at }.sort_by(&:stopped_at).last.try(:stopped_at)
  end
  
  # ===============
  # = Validations =
  # ===============
  
  # =========
  # = Hooks =
  # =========
  # after_destroy :clean_timers, :clean_expenses
  after_save :email_invoice
  before_create :print_receipt
  
  def email_invoice
    Mailer.deliver_invoice(self) unless invoice_emails.empty?
  end
  
  def clean_timers
    timers.each do |timer| 
      Timer.update_all({:invoice_id => nil}, {:id => timer.id})
    end
  end
  def clean_expenses
    expenses.each do |expense| 
      Expense.update_all({:invoice_id => nil}, {:id => expense.id})
    end
  end

  def print_receipt(my_timers = timers, my_expenses = expenses)
    self.total = tally_total
    receipt = {:projects => {}, :hours => hours, :total => tally_total}
    
    my_projects = projects.all(:include => [:uninvoiced_timers, :uninvoiced_expenses])

    my_projects.each do |project|
      project_timers = my_timers.select{ |timer| timer.project_id == project.id }
      project_expenses = my_expenses.select{ |expense| expense.project_id == project.id }
      next if project_timers.length + project_expenses.length == 0
      receipt[:projects][project.name] = {
        :hours => project_timers.map(&:hours).sum, 
        :total => project_timers.map(&:cost).sum + project_expenses.map(&:cost).sum,
        :expense_total => project_expenses.map(&:cost).sum,
        :timers_total => project_timers.map(&:cost).sum,
        :timers => project_timers.map{ |timer| timer.attributes.merge!({
          :billing_rate => timer.user.billing_rate,
          :task_name => timer.task_name,
          :hours => timer.hours
        })},
        :expenses => project_expenses.map{ |expense| expense.attributes }
      }
    end
    
    self.info = receipt.to_yaml
    return self
  end
    
  # ====================
  # = Instance Methods =
  # ====================
  def paid_in_full?
    balance.round <= 0
  end
  
  def balance
    total.to_f - amount_paid.to_f
  end
  
  def load_info
    YAML.load(info)
  end
  
  def total_hours
    timers.map{ |item| item.hours }.sum
  end
  alias_method :hours, :total_hours
  
  def tally_total
    timers_cost + expenses_cost
  end
  
  def tally_total_from_receipt
    tally_timer_total_from_receipt + tally_expense_total_from_receipt
  end
  
  def tally_timer_total_from_receipt
    load_info[:projects].map{ |k, v| v[:timers]}.flatten.map{|item| item[:billing_rate] * item[:hours]}.sum
  end
  
  def tally_expense_total_from_receipt
    load_info[:projects].map{ |k, v| v[:expenses] || []}.flatten.map{|item| item['cost']}.sum
  end
  
  def timers_cost
    timers.map{ |item| item.hours * item.user.billing_rate }.sum
  end
  
  def expenses_cost
    expenses.map(&:cost).sum
  end
    
  # ======================
  # = Virtual Attributes =
  # ======================
  def payment=(amount)
    self.amount_paid = amount_paid.to_f + amount.to_f
  end
  
  def email_ids=(ids)
    self.invoice_emails = contacts.id_is_any(ids).map(&:email)
  end
  
  def invoicing_timer_ids=(ids)
    self.timers = client.timers.id_is_any(ids)
  end
  
  def invoicing_expense_ids=(ids)
    self.expenses = client.expenses.id_is_any(ids)
  end
  
end