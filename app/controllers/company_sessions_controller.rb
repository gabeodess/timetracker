class CompanySessionsController < ApplicationController
  
  skip_before_filter :company_login_required
  
  def create
    @company = current_user.companies.url_id_is(params[:id]).first
    if session[:company_id] = @company.try(:url_id)
      redirect_to :dashboard
    else
      flash[:notice] = "You do not have access to that company."
      redirect_to :login
    end
  end
  
end
