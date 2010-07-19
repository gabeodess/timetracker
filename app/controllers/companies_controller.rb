class CompaniesController < ApplicationController
  skip_before_filter :company_login_required, :only => [:show, :new, :create]
  filter_resource_access
  def index
    @companies = Company.paginate(:page => params[:page])
  end
  
  def show
    @company = Company.find_by_url_id(params[:id])
    session[:company_id] = @company.url_id if @company and @company.user_ids.include?(current_user.id)
  end
  
  def new
    @company = Company.new
  end
  
  def create
    @company = Company.new(params[:company])
    @company.owner_id = current_user.id
    if @company.save
      CompanyBasedRole.create!(:name => 'admin', :user => current_user, :company => @company)
      flash[:notice] = "Successfully created company."
      redirect_to @company
    else
      render :action => 'new'
    end
  end
  
  def edit
    @company = Company.find(params[:id])
  end
  
  def update
    @company = Company.find(params[:id])
    if @company.update_attributes(params[:company])
      flash[:notice] = "Successfully updated company."
      redirect_to @company
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    flash[:notice] = "Successfully destroyed company."
    redirect_to companies_url
  end
  
  protected
    def load_company
      @company = Company.find_by_url_id(params[:id])
    end
  
end
