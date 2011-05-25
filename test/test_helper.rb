ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'declarative_authorization/maintenance'

class ActiveSupport::TestCase
  include Authorization::TestHelper
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def login_as(user)
    session[:user_id] = users(user).id
  end
 
  def logout
    session.delete :user_id
  end
 
  def setup
    @company = Factory(:company)
    @user = @company.owner
    @client = @company.clients.first
    @project = @client.projects.first
    @task = Factory(:task, :company_id => @company.id)
    load_project
    
    @invoice = Factory(:invoice, {
      :client => @client, 
      :timers => [add_timer_to_project], 
      :expenses => [add_expense_to_project]
    })
    @session_vars = {:user_id => @user.id, :company_id => @company.url_id}
  end
  
  def admin
    u = users(:admin)
    u.company_based_roles << CompanyBasedRole.new(:name => 'admin')
    return u
  end
  
  def load_project
    add_timer_to_project
    add_expense_to_project
  end
  
  def add_timer_to_project
    Factory(:timer, {:user => @user, :associated_task => @project.associated_tasks.random_element})
  end

  def add_expense_to_project
    Factory(:expense, :project => @project)
  end
  
  # ==================
  # = Method Missing =
  # ==================
  def method_missing(method, *args)
    begin
      super
    rescue Exception => e
      method = method.to_s
      case method = method.to_s
      when /_login_required$/
        http_method = method.gsub(/_\w+$/,'')
        do_login_required(http_method, *args)
      when /^(get|post|put|delete)_/
        http_method = method.gsub(/_\w+$/,'')
        template = method.gsub(/^[a-z]+_/,'')
        do_template(http_method, template, *args)
      else
        super
      end
    end
  end
  
  def do_login_required(http_method, *args)
    send(http_method, *args)
    assert_redirected_to login_url
    assert flash[:notice]
  end
  
  def do_template(http_method, template, *args)
    do_ok(http_method, *args)
    assert_template(template)
  end
  
  def do_ok(http_method, *args)
    send(http_method, *args)
    assert_response :ok
  end
    
end
require 'mocha'