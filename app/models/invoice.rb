class Invoice < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :client
  # has_many :contacts, :through => :client
  has_many :timers
  
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
  # attr_accessible :email_ids
  attr_protected :info, :invoice_emails
  
  # ===============
  # = Validations =
  # ===============
  
  # =========
  # = Hooks =
  # =========
  after_destroy :clean_timers
  after_save :email_invoice
  before_create :print_receipt
  
  def email_invoice
    Mailer.deliver_invoice(self)
  end
  
  def clean_timers
    timers.each do |timer| 
      Timer.update_all({:invoice_id => nil}, {:id => timer.id})
    end
  end
  
  def print_receipt
    receipt = {:projects => {}, :hours => 0, :total => 0}

    projects = timers.map{ |item| item.project.name }.uniq
    projects.each do |project|
      my_timers = timers.select{ |item| item.project_name == project }
      puts my_timers.map{ |item| item.attributes.merge!({
        :billing_rate => item.user.billing_rate,
        :task_name => item.task_name,
        :hours => item.hours
      })}.inspect
      receipt[:projects][project] = {
        :hours => my_timers.map(&:hours).sum, 
        :total => my_timers.map(&:total_cost).sum,
        :timers => my_timers.map{ |item| item.attributes.merge!({
          :billing_rate => item.user.billing_rate,
          :task_name => item.task_name,
          :hours => item.hours
        })}
      }
    end
    
    self.info = receipt.to_yaml
    return self
  end
  
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
    timers.map{ |item| item.hours * item.user.billing_rate }.sum
  end
  alias_method :total_cost, :total
  
  def uninvoiced_timers
    client ? client.timers.all(:conditions => "invoice_id is null and timer_started_at is null") : []
  end
  
  def invoiced_timers
    client ? client.timers.invoice_id_gt(0) : []
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
  
end