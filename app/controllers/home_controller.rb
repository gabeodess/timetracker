class HomeController < ApplicationController
  
  skip_before_filter :login_required, :company_login_required
  
  def index
  end

end
