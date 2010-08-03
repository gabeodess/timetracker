class Assignment < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :task
  belongs_to :user

  
  
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
  validates_format_of :hours, :with => /^\d+$|^\d+\.\d+$|^\d+:\d{2}$/
  
  # ====================
  # = Instance Methods =
  # ====================
  def start_timer
    Assignment.user_id_is(user_id).all(:conditions => "timer_started_at is not null").each do |assignment|
      assignment.stop_timer
    end
    self.timer_started_at = Time.now
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