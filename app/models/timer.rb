class Timer < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ==========
  # = Scopes =
  # ==========
  default_scope :order => "timers.created_at ASC"
  
  # ================
  # = Associations =
  # ================
  belongs_to :associated_task
  belongs_to :user
  
  def project_id
    associated_task.project_id
  end
  def project
    associated_task.project
  end
  
  def task
    associated_task.task
  end
  
  def company_id
    associated_task.project.client.company_id
  end
  def company
    Company.id_is(company_id).first
  end
  
  def client
    project.client
  end
  
  # ==============
  # = Attributes =
  # ==============
  
  # => Using composed of allows us to an attribute writer with multiparameter attributes.
  # BUG: The time gets set as UTC instead of the environment's time zone.
  composed_of :stop_and_set,
              :class_name => 'Time',
              :mapping => %w(Time to_s),
              :constructor => Proc.new{ |item| item },
              :converter => Proc.new{ |item| item }
              
  attr_protected :timer_started_at, :stopped_at
  
  # =========
  # = Hooks =
  # =========
  before_create :initial_timer_status
  before_save :stop_and_set_now

  def stop_and_set_now
    if stop_and_set
      
      # => Convert stop_and_set to the environment's time zone.
      time = Time.zone.parse(stop_and_set.to_s(:number))
      
      time_worked = total_time + (time - timer_started_at)
      stop_timer
      self.total_time = time_worked
    end
  end
  
  def initial_timer_status
    start_timer if total_time.to_i == 0
  end
  
  # ===============
  # = Validations =
  # ===============
  validates_inclusion_of :total_time, :in => -2147483648..2147483647, :message => "is out of range."
  validates_presence_of :associated_task, :user
  validates_format_of :hours, :with => /^\d+$|^\d+\.\d+$|^\d+:\d{2}$/
  
  # ====================
  # = Instance Methods =
  # ====================
  def billing_rate
    return_value =
      case project.billing
      when 'user'
        user.billing_rate
      when 'project'
        project.billing_rate
      when 'non_billable'
        0
      else
        raise "invalid billing option."
      end
    return return_value
  end
  
  def total_cost
    hours * billing_rate
  end
  alias_method :cost, :total_cost
  
  def client_name
    associated_task.project.client.name
  end
  
  def project_name
    associated_task.project.name
  end
  
  def task_name
    associated_task.task.name
  end
  
  def calculate_total_time
    return timer_running? ? 
       total_time.to_i + (Time.now - timer_started_at) :
       total_time
  end
  
  def calculate_total_time_in_hours
    (calculate_total_time.to_f/3600).round_with_precision(2)
  end
  
  def sibling_timers
    company.timers.user_id_is(user_id)
  end
  
  def runaway_timers
    sibling_timers.timer_started_at_lt(Time.now.beginning_of_day).all(:conditions => "timer_started_at is not null")
  end
  
  def todays_running_siblings
    # => returns all running timers from this user and this company and this day.
    sibling_timers.timer_started_at_gt(Time.now.beginning_of_day).all(:conditions => "timer_started_at is not null")
  end
    
  def hours
    @hours ||= hours!
  end
  def hours!
    total_time.to_f/3600
  end
  
  def readable_hours
    [hours.to_i, ':', ((hours - hours.to_i) * 60).round]
  end
  alias_method :hours_readable, :readable_hours
  
  def timer_action
    timer_running? ? stop_timer_display : start_timer_display
  end
  
  def timer_running?
    timer_started_at?
  end
  alias_method :running?, :timer_running?
  
  def stopped?
    !running?
  end
  
  def start_timer_display
    "start timer"
  end
  
  def stop_timer_display
    "stop timer"
  end
  
  # ======================
  # = Virtual Attributes =
  # ======================  
  def hours=(value)
    if value.to_s.include?(':')
      array = value.split(":")
      self.total_time = (array[0].to_i * 3600 + array[1].to_i * 60)
    else
      self.total_time = (value.to_f * 3600).to_i
    end
  end
  
  def toggle_timer=(value)
    if timer_running?
      stop_timer
    else
      start_timer
    end
  end
  
  # ==================
  # = Update Methods =
  # ==================
  def start_timer
    # => Stop all timers for this user from this company for today.
    todays_running_siblings.each do |timer|
      
      # => We have to reload this timer to avoid an ActiveRecord::ReadOnlyRecord error.
      Timer.find(timer.id).stop_timer!
      
    end
    
    # => start timer.
    self.timer_started_at = Time.now
    self.stopped_at = nil
  end
  
  def stop_timer(options = {})
    return true if stopped?
    self.total_time = total_time.to_i + (Time.now - timer_started_at)
    self.timer_started_at = nil
    self.stopped_at = Time.now
  end
  def stop_timer!
    stop_timer
    save!
  end
  
end