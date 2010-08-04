class AssociatedTasksController < ApplicationController
  
  filter_resource_access
  
  def index
    @search = AssociatedTask.search(params[:search])
    @associated_tasks = @search.paginate(:page => params[:page], :include => [:task])
    respond_to do |format|
      format.html
      format.xml{ render :xml => @search.to_xml(:include => [:task]) }
    end
  end
  
  def show
    @associated_task = AssociatedTask.find(params[:id])
  end
  
  def new
    @associated_task = AssociatedTask.new
  end
  
  def create
    @associated_task = AssociatedTask.new(params[:associated_task])
    if @associated_task.save
      flash[:notice] = "Successfully created associated task."
      redirect_to @associated_task
    else
      render :action => 'new'
    end
  end
  
  def edit
    @associated_task = AssociatedTask.find(params[:id])
  end
  
  def update
    @associated_task = AssociatedTask.find(params[:id])
    if @associated_task.update_attributes(params[:associated_task])
      flash[:notice] = "Successfully updated associated task."
      redirect_to @associated_task
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @associated_task = AssociatedTask.find(params[:id])
    @associated_task.destroy
    flash[:notice] = "Successfully destroyed associated task."
    redirect_to associated_tasks_url
  end
end
