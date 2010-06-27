# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  before_filter :my_basic_auth, :redirect_no_www
    
  protected
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
    
    

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
