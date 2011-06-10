class HomeController < ApplicationController
  
  layout "external"
  
  skip_before_filter :login_required, :company_login_required
  
  def index
  end

end
