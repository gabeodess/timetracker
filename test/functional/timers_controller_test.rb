require 'test_helper'

class TimersControllerTest < ActionController::TestCase
  test "siblings are stopped when timer is started" do
    company = Company.first
    client = Client.first
    project = Project.first
    task = Task.first
    user = User.first
    timer1 = Timer.first
    timer2 = Timer.last
    
    CompanyBasedRole.create!(:user => user, :company => company, :name => 'admin')
    company.clients << client
    project.tasks << task
    associated_task = project.associated_tasks.first
    timer1.associated_task = associated_task
    timer2.associated_task = associated_task
    timer1.stop_timer!
    timer2.stop_timer!
    client.projects << project
    user.timers = [timer1, timer2]
    
    put(:update, {:id => timer1.id, :timer => {:toggle_timer => true, :associated_task_id => associated_task.id}}, {:user_id => user.id})
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert(assigns(:timer).todays_running_siblings.length == 1)

    put(:update, {:id => timer1.id, :timer => {:toggle_timer => true, :associated_task_id => associated_task.id}}, {:user_id => user.id})
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert(assigns(:timer).todays_running_siblings.length == 0)

    put(:update, {:id => timer1.id, :timer => {:toggle_timer => true, :associated_task_id => associated_task.id}}, {:user_id => user.id})
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert(assigns(:timer).todays_running_siblings.length == 1)
    
    put(:update, {:id => timer2.id, :timer => {:toggle_timer => true, :associated_task_id => associated_task.id}}, {:user_id => user.id})
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert(assigns(:timer).todays_running_siblings.length == 1)
    
  end
end
