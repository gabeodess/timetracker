class AssignedProjectsController < ApplicationController
  filter_resource_access
  def index
    @assigned_projects = AssignedProject.paginate(:page => params[:page])
  end
  
  def show
    @assigned_project = AssignedProject.find(params[:id])
  end
  
  def new
    @assigned_project = AssignedProject.new
  end
  
  def create
    @assigned_project = AssignedProject.new(params[:assigned_project])
    if @assigned_project.save
      flash[:notice] = "Successfully created assigned project."
      redirect_to @assigned_project
    else
      render :action => 'new'
    end
  end
  
  def edit
    @assigned_project = AssignedProject.find(params[:id])
  end
  
  def update
    @assigned_project = AssignedProject.find(params[:id])
    if @assigned_project.update_attributes(params[:assigned_project])
      flash[:notice] = "Successfully updated assigned project."
      redirect_to @assigned_project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @assigned_project = AssignedProject.find(params[:id])
    @assigned_project.destroy
    flash[:notice] = "Successfully destroyed assigned project."
    redirect_to assigned_projects_url
  end
end
