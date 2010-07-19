class CompanyBasedRolesController < ApplicationController
  filter_resource_access
  def index
    @company_based_roles = CompanyBasedRole.paginate(:page => params[:page])
  end
  
  def show
    @company_based_role = CompanyBasedRole.find(params[:id])
  end
  
  def new
    @company_based_role = CompanyBasedRole.new
  end
  
  def create
    @company_based_role = CompanyBasedRole.new(params[:company_based_role])
    if @company_based_role.save
      flash[:notice] = "Successfully created company based role."
      redirect_to @company_based_role
    else
      render :action => 'new'
    end
  end
  
  def edit
    @company_based_role = CompanyBasedRole.find(params[:id])
  end
  
  def update
    @company_based_role = CompanyBasedRole.find(params[:id])
    if @company_based_role.update_attributes(params[:company_based_role])
      flash[:notice] = "Successfully updated company based role."
      redirect_to @company_based_role
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @company_based_role = CompanyBasedRole.find(params[:id])
    @company_based_role.destroy
    flash[:notice] = "Successfully destroyed company based role."
    redirect_to company_based_roles_url
  end
end
