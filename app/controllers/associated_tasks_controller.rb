class AssociatedTasksController < ApplicationController
  
  filter_resource_access
  
  def index
    @project = current_company.projects.find(params[:project_id])
    @search = @project.associated_tasks.search(params[:search])
    @associated_tasks = @search.paginate(:page => params[:page], :include => [:task])
    respond_to do |format|
      format.html
      format.xml{ render :xml => @search.to_xml(:include => [:task]) }
    end
  end
  
end
