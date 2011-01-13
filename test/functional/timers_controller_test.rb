require 'test_helper'

class TimersControllerTest < ActionController::TestCase
  
  test "index should not include invoiced timers" do
    company = Factory(:company)
    client = company.clients.first
    project = client.projects.first
    task = company.tasks.first
    user = company.owner
    timer1 = create_timer(client, user, :invoice_id => 1)
    timer2 = create_timer(client, user)
    get_index(:index, {}, {:user_id => user.id, :company_id => company.url_id})
    assert assigns(:timers) == [timer2]
  end
  
  test "siblings are stopped when timer is started" do
    company = Factory(:company)
    client = company.clients.first
    project = client.projects.first
    task = company.tasks.first
    user = company.owner
    timers = []
    2.times do |i|
      timers << Factory(:timer, {
        :associated_task => client.projects.map(&:associated_tasks).flatten.random_element, :user => user
      })
    end
    timer1 = timers[0]
    timer2 = timers[1]
    
    timer1.stop_timer!
    timer2.stop_timer!
    
    put(
      :update, 
      {:id => timer1.id, :timer => {:toggle_timer => true}}, 
      {:user_id => user.id, :company_id => company.url_id}
    )
    assert assigns(:timer)
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert(assigns(:timer).todays_running_siblings.length == 1)

    put(:update, {:id => timer1.id, :timer => {:toggle_timer => true}}, {:user_id => user.id, :company_id => company.url_id})
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert(assigns(:timer).todays_running_siblings.length == 0)

    put(:update, {:id => timer1.id, :timer => {:toggle_timer => true}}, {:user_id => user.id, :company_id => company.url_id})
    assert !Timer.find(timer2.id).running?, [timer1.id, timer2.id].inspect
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert(assigns(:timer).todays_running_siblings.length == 1)
    
    put(:update, {:id => timer2.id, :timer => {:toggle_timer => true}}, {:user_id => user.id, :company_id => company.url_id})
    assert_redirected_to(timers_url(:anchor => "project_#{assigns(:timer).project.id}"))
    assert((timer = assigns(:timer)).todays_running_siblings.length == 1)
    
  end
  
  # ===========
  # = Private =
  # ===========
  private
  def create_timer(client, user, options = {})
    Factory(:timer, {
      :associated_task => client.projects.map(&:associated_tasks).flatten.random_element, :user => user
    }.merge(options))
  end
  
end
