# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  before_filter :login_required, :company_login_required, :mobile_setup
  before_filter :my_basic_auth, :redirect_no_www
  
  helper_method :current_company
    
  protected
    def mobile_setup
      request.format = 'mobile' if request.user_agent.downcase =~ /mobile|webos/
    end
  
    def company_login_required
      
      unless current_company and current_company.user_ids.include?(current_user.id)
        logout_company
        flash[:notice] = "Please login through a company."
        redirect_to :root
        return
      end
      
      current_user.current_company = current_company
    end
    
    def logout_company
      session[:company_id] = nil
    end
  
    def current_company
      Company.find_by_url_id(session[:company_id])
    end
  
    def set_iphone_format
      if is_iphone_request?
        request.format = :iphone
      end
    end
    
    def is_iphone_request?
      request.user_agent =~ /(Mobile\/.+Safari)/
    end
    
    def redirect_no_www      
      if request.host.match(/^www/)
        headers["Status"] = "301 Moved Permanently"
        redirect_to(request.protocol + request.host.gsub(/^www./, '') + request.path)
      end
    end
    
    def my_basic_auth
      if APP_CONFIG['perform_authentication']
        authenticate_or_request_with_http_basic do |username, password|
          username == APP_CONFIG['username'] && password == APP_CONFIG['password']
        end
      end
    end
end