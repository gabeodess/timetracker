class ProjectsController < ApplicationController
  filter_resource_access
  
  before_filter :get_collections, :only => [:new, :create, :edit, :update]
  
  def index
    @projects = current_company.projects.paginate(:page => params[:page])
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def new
    # @project = Project.new(params[:project])
  end
  
  def create
    # @project = Project.new(params[:project])
    if @project.save
      flash[:notice] = "Successfully created project."
      redirect_to @project
    else
      render :action => 'new'
    end
  end
  
  def edit
    @project = Project.find(params[:id])
  end
  
  def update
    @project = Project.find(params[:id])
    params[:project][:task_ids] ||= []
    if @project.update_attributes(params[:project])
      flash[:notice] = "Successfully updated project."
      redirect_to @project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    flash[:notice] = "Successfully destroyed project."
    redirect_to projects_url
  end
    
  protected
  def get_collections
    @clients = current_company.clients
    @tasks = current_company.tasks
  end
  
  def new_controller_object_from_params(*args)
    @project = Project.new(params[:project])
    @project.client_id = params[:project].try(:[], :client_id)
  end
  
end
