class Assignment < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ==========
  # = Scopes =
  # ==========
  default_scope :order => "created_at ASC"
  
  # ================
  # = Associations =
  # ================
  belongs_to :associated_task
  belongs_to :user
  
  def company_id
    associated_task.project.client.company_id
  end
  def company
    Company.id_is(company_id).first
  end
  
  # ==============
  # = Attributes =
  # ==============
  
  # =========
  # = Hooks =
  # =========
  before_create :initial_timer_status
  
  def initial_timer_status
    start_timer if total_time.to_i == 0
  end
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :associated_task
  validates_format_of :hours, :with => /^\d+$|^\d+\.\d+$|^\d+:\d{2}$/
  
  # ====================
  # = Instance Methods =
  # ====================
  def client_name
    associated_task.project.client.name
  end
  
  def project_name
    associated_task.project.name
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
    company.assignments.user_id_is(user_id)
  end
  
  def runaway_timers
    sibling_timers.timer_started_at_lt(Time.now.beginning_of_day).all(:conditions => "timer_started_at is not null")
  end
  
  def todays_running_siblings
    # => returns all running assignments from this user and this company and this day.
    sibling_timers.timer_started_at_gt(Time.now.beginning_of_day).all(:conditions => "timer_started_at is not null")
  end
  
  def start_timer
    # => Stop all timers for this user from this company for today.
    todays_running_siblings.each do |assignment|
      assignment.stop_timer
    end
    self.timer_started_at = Time.now #unless created_at < Time.now.beginning_of_day
  end
  
  def stop_timer
    Assignment.update_all(
      {:total_time => total_time.to_i + (Time.now - timer_started_at), :timer_started_at => nil}, {:id => id}
    )
  end
  
  def hours
    return (total_time.to_f/3600).to_f.round_with_precision(2)
  end
  
  def timer_action
    timer_running? ? stop_timer_display : start_timer_display
  end
  
  def timer_running?
    timer_started_at?
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
    puts "hello from hours= #{value}"
    if value.include?(':')
      puts "hello from :"
      array = value.split(":")
      puts "array = #{array.inspect}"
      self.total_time = (array[0].to_i * 3600 + array[1].to_i * 60)
    else
      self.total_time = (value.to_f * 3600).to_i
    end
    puts "total_time = #{self.total_time}"
  end
  
  def toggle_timer=(value)
    if timer_running?
      stop_timer
    else
      start_timer
    end
  end
  
end