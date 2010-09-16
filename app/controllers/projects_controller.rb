class ProjectsController < ApplicationController
  filter_resource_access
  
  before_filter :get_collections, :only => [:new, :create, :edit, :update]
  
  def index
    @projects = current_company.projects.paginate(:page => params[:page])
  end
  
  def show
    @project = Project.find(params[:id])
  end
  
  def create
    if @project.save
      flash[:notice] = "Successfully created project."
      redirect_to @project
    else
      render :action => 'new'
    end
  end
    
  def update
    @project = Project.find(params[:id])
    # params[:project][:task_ids] ||= []
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
    redirect_to @project.client
  end
    
  protected
  def get_collections
    @clients = current_company.clients
    @tasks = current_company.tasks
    @tasks.each do |task|
      @project.associated_tasks.build(:task => task) unless @project.tasks.include?(task)
    end
  end
  
  def new_controller_object_from_params(*args)
    @project = Project.new(params[:project])
    @project.client_id = params[:project].try(:[], :client_id)
  end
  
end
