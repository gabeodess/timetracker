class Invoice < ActiveRecord::Base
  
  def after_initialize
    self.invoice_emails ||= []
  end
  
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
  attr_accessor :invoice_emails, :email_ids
  attr_protected :info, :invoice_emails, :timer_ids, :expense_ids
  
  # ===============
  # = Validations =
  # ===============
  
  # =========
  # = Hooks =
  # =========
  # after_destroy :clean_timers
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

  def print_receipt(my_timers = uninvoiced_timers, my_expenses = uninvoiced_expenses)    
    receipt = {:projects => {}, :hours => 0, :total => 0}
    
    my_projects = projects.all(:include => [:uninvoiced_timers, :uninvoiced_expenses])

    my_projects.each do |project|
      next if project.uninvoiced_timers.length + project.uninvoiced_expenses.length == 0
      receipt[:projects][project.name] = {
        :hours => project.uninvoiced_hours, 
        :total => project.uninvoiced_cost,
        :expense_total => project.uninvoiced_expense_cost,
        :timers_total => project.uninvoiced_timer_cost,
        :timers => project.uninvoiced_timers.map{ |timer| timer.attributes.merge!({
          :billing_rate => timer.user.billing_rate,
          :task_name => timer.task_name,
          :hours => timer.hours
        })},
        :expenses => project.uninvoiced_expenses.map{ |expense| expense.attributes }
      }
    end
    
    self.info = receipt.to_yaml
    return self
  end
  
  # def print_receipt(my_timers = uninvoiced_timers, my_expenses = uninvoiced_expenses)    
  #   receipt = {:projects => {}, :hours => 0, :total => 0}
  # 
  #   projects = all_timers.map{ |item| item.project.name }.uniq
  #   projects.each do |project|
  #     selected_timers = my_timers.select{ |item| item.project_name == project }
  #     receipt[:projects][project] = {
  #       :hours => selected_timers.map(&:hours).sum, 
  #       :total => selected_timers.map(&:total_cost).sum,
  #       :timers => selected_timers.map{ |item| item.attributes.merge!({
  #         :billing_rate => item.user.billing_rate,
  #         :task_name => item.task_name,
  #         :hours => item.hours
  #       })},
  #       :expenses => my_expenses.select{ |expense| 
  #           expense.project.name == project }.map{ |expense| 
  #           expense.attributes }
  #     }
  #   end
  #   
  #   self.info = receipt.to_yaml
  #   return self
  # end
  
  # ====================
  # = Instance Methods =
  # ====================
  def load_info
    YAML.load(info)
  end
  
  def total_hours
    timers.map{ |item| item.hours }.sum
  end
  
  def total
    timers_cost + expenses_cost
  end
  alias_method :total_cost, :total
  
  def timers_cost
    timers.map{ |item| item.hours * item.user.billing_rate }.sum
  end
  
  def expenses_cost
    expenses.map(&:cost).sum
  end
    
  # ======================
  # = Virtual Attributes =
  # ======================
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