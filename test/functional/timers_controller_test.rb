require 'test_helper'

class TimersControllerTest < ActionController::TestCase
  
  def setup
    @company = Factory(:company)
    @user = @company.owner
    @project = @company.clients.first.projects.first
    @task = @company.tasks.first
    @associated_task = Factory(:associated_task, :project => @project, :task => @task)
    @timer = Factory(:timer, {
      :total_time => 200, 
      :timer_started_at => 24.hours.ago, 
      :associated_task => @associated_task,
      :user => @user
    })
    @session_vars = {:user_id => @user.id, :company_id => @company.url_id}
  end
  
  # =========
  # = Index =
  # =========
  test "should get index" do
    get_index :index, {}, @session_vars
  end
  
  # ========
  # = Show =
  # ========
  test "should get show" do
    get_show :show, {:id => @timer}, @session_vars
  end
  
  # ========
  # = Edit =
  # ========
  test "should get edit" do
    get_edit :edit, {:id => @timer}, @session_vars
  end
  
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
