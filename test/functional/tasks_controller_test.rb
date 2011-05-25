require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  def test_index_unauthorized
    get_login_required :index
  end

  def test_index
    get_index :index, {}, {:user_id => @user, :company_id => @company.url_id}
  end
  
  def test_show_invalid
    get_login_required :show, :id => @task
  end
  
  def test_show
    get_show :show, {:id => @task}, {:user_id => @user, :company_id => @company.url_id}
  end
  
  def test_new_invalid
    get_login_required :new
  end
  
  def test_new
    get_new :new, {}, {:user_id => @user, :company_id => @company.url_id}
  end
  
  def test_create_unauthorized
    post_login_required :create
  end
  
  def test_create_invalid
    Task.any_instance.stubs(:valid?).returns(false)
    post_new :create, {}, {:user_id => @user, :company_id => @company.url_id}
  end
  
  def test_create_valid
    Task.any_instance.stubs(:valid?).returns(true)
    post :create, {}, {:user_id => @user, :company_id => @company.url_id}
    assert_redirected_to dashboard_url
  end
  
  def test_edit_unauthorized
    get_login_required :edit, :id => @task
  end
  
  def test_edit
    get_edit :edit, {:id => @task}, {:user_id => @user, :company_id => @company.url_id}
  end
  
  def test_update_unauthorized
    put_login_required :update, :id => @task
  end
  
  def test_update_invalid
    Task.any_instance.stubs(:valid?).returns(false)
    put_edit :update, {:id => @task}, {:user_id => @user, :company_id => @company.url_id}
  end
  
  def test_update_valid
    Task.any_instance.stubs(:valid?).returns(true)
    put :update, {:id => @task}, {:user_id => @user, :company_id => @company.url_id}
    assert_redirected_to dashboard_url
  end
  
  def test_destroy_unauthorized
    task = @task
    delete_login_required :destroy, :id => task
    assert Task.exists?(task.id)
  end
  
  def test_destroy
    task = @task
    delete :destroy, {:id => task}, {:user_id => @user, :company_id => @company.url_id}
    assert_redirected_to dashboard_url
    assert !Task.exists?(task.id)
  end
  
  # private
  # def method_missing(*args)
  #   uri = args[1]
  #   params = args[2] || {}
  #   session_options = args[3] || {}
  #   
  #   case args[0].to_s
  #   when /^(get|put|post|delete)_login_required$/
  #     http_method = args[0].to_s.gsub(/_login_required$/, '')
  #     do_login_required(http_method, uri, params, session_options)
  #   when /^get_/
  #     template = args[0].to_s.gsub(/^get_/, '')
  #     uri ||= template
  #     get_template(template, uri, params, session_options)
  #   else
  #     super
  #   end
  # end
  # 
  # def get_template(template, uri, params, session_options)
  #   get_ok(uri, params, session_options)
  #   assert_template template
  # end
  #   
  # def do_login_required(http_method, uri, params = {}, session_options = {})
  #   send(http_method, uri, params, session_options)
  #   assert @response.redirect_url.match(log_in_url), @response.redirect_url
  #   assert flash[:notice]
  # end
  
  
end
