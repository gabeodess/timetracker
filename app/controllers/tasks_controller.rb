class TasksController < ApplicationController
  filter_resource_access
  before_filter :get_collections, :only => [:new, :create, :edit, :update]
  def index
    @search = current_company.tasks.search(params[:search])
    @tasks = @search.paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.xml{ render :xml => @search.all.to_xml }
    end
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new(params[:task])
  end
  
  def create
    @task = Task.new(params[:task])
    @task.company = current_company
    if @task.save
      flash[:notice] = "Successfully created task."
      redirect_to :dashboard
    else
      render :action => 'new'
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = "Successfully updated task."
      redirect_to :dashboard
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = "Successfully destroyed task."
    redirect_to :dashboard
  end
  
  protected
  def get_collections
    @projects = current_company.projects
  end
end
