class AssignmentsController < ApplicationController
  before_filter :get_collections
  def index
    @assignments = Assignment.paginate(:page => params[:page])
  end
  
  def show
    @assignment = Assignment.find(params[:id])
    respond_to do |format|
      format.html
      format.xml{ render :xml => @assignment.to_xml(:methods => [:calculate_total_time_in_hours]) }
    end
  end
  
  def new
    @assignment = Assignment.new
  end
  
  def create
    @assignment = Assignment.new(params[:assignment])
    @assignment.user_id = current_user.id
    if @assignment.save
      flash[:notice] = "Successfully created assignment."
      redirect_to :assignments
    else
      render :action => 'new'
    end
  end
  
  def edit
    @assignment = Assignment.find(params[:id])
  end
  
  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "Successfully updated assignment."
      redirect_to :assignments
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    flash[:notice] = "Successfully destroyed assignment."
    redirect_to assignments_url
  end
  
  protected
  def get_collections
    @projects = current_company.projects.all(:include => [:client])
  end
end
