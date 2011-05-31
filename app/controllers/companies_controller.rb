class CompaniesController < ApplicationController
  skip_before_filter :company_login_required, :only => [:show, :new, :create]
  filter_resource_access
  def index
    @companies = current_user.companies.paginate(:page => params[:page])
  end
  
  def show
    @company = Company.find_by_url_id(params[:id])
    session[:company_id] = @company.url_id if @company and @company.user_ids.include?(current_user.id)
  end
  
  def new
    @company = Company.new(params[:company])
  end
  
  def create
    @company = Company.new(params[:company])
    @company.owner_id = current_user.id
    if @company.save
      flash[:notice] = "Successfully created company."
      redirect_to current_user
    else
      render :action => 'new'
    end
  end
  
  def update
    if @company.update_attributes(params[:company])
      flash[:notice] = "Successfully updated company."
      redirect_to :dashboard
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @company = Company.find_by_url_id(params[:id])
    @company.destroy
    flash[:notice] = "Successfully destroyed company."
    redirect_to current_user
  end
  
  protected
    def load_company
      @company = Company.find_by_url_id(params[:id])
    end
  
end
