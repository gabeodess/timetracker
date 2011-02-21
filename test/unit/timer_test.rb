require 'test_helper'
class TimerTest < ActiveSupport::TestCase

  def setup
    company = Factory(:company)
    @user = company.owner
    @project = company.clients.first.projects.first
    @task = company.tasks.first
    @associated_task = Factory(:associated_task, :project => @project, :task => @task)
  end
  
  test "should stop timer and set total time" do
    timer = Factory(:timer, {
      :total_time => 3600, 
      :timer_started_at => 24.hours.ago, 
      :associated_task => @associated_task,
      :user => @user
    })
    assert timer.total_time == 3600, timer.hours!
    assert timer.timer_started_at
    timer.update_attributes({:stop_and_set => 23.hours.ago})
    assert_equal timer.reload.hours!.round_with_precision(2), 2, timer.reload.hours!
    assert !timer.timer_started_at
  end

  test "should stop timer and set total time with multiparameter attributes" do
    timer = Factory(:timer, {
      :total_time => 3600, 
      :timer_started_at => 24.hours.ago, 
      :associated_task => @associated_task,
      :user => @user
    })
    assert_equal timer.total_time, 3600
    assert timer.timer_started_at
    
    time = timer.timer_started_at + 1.hour
    timer.update_attributes({
      "stop_and_set(1i)"=>time.year.to_s, 
      "stop_and_set(2i)"=>time.month.to_s, 
      "stop_and_set(3i)"=>time.day.to_s,
      "stop_and_set(4i)"=>time.hour.to_s, 
      "stop_and_set(5i)"=>time.min.to_s
    })
    assert (timer.reload.hours! - 2).abs < 0.02, (timer.reload.hours! - 2).abs
    assert !timer.timer_started_at
  end

end
