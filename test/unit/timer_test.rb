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
      :total_time => 200, 
      :timer_started_at => 24.hours.ago, 
      :associated_task => @associated_task,
      :user => @user
    })
    assert timer.total_time == 200
    assert timer.timer_started_at
    timer.update_attributes({:stop_and_set => 400})
    assert timer.reload.hours! == 400, timer.reload.hours!
    assert !timer.timer_started_at
  end

end
