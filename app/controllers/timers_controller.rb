class TimersController < ApplicationController
  before_filter :get_collections
  def index
    @timers = current_company.timers.user_id_is(current_user.id).paginate(:page => params[:page], :conditions => "invoice_id is null")
  end
  
  def show
    @timer = Timer.find(params[:id])
    respond_to do |format|
      format.html
      format.xml{ render :xml => @timer.to_xml(:methods => [:calculate_total_time_in_hours]) }
    end
  end
  
  def new
    @timer = Timer.new
  end
  
  def create
    @timer = Timer.new(params[:timer])
    @timer.user_id = current_user.id
    if @timer.save
      flash[:notice] = "Successfully created timer."
      redirect_to :timers
    else
      render :action => 'new'
    end
  end
  
  def edit
    @timer = Timer.find(params[:id])
  end
  
  def update
    @timer = Timer.find(params[:id])
    if @timer.update_attributes(params[:timer])
      flash[:notice] = "Successfully updated timer."
      redirect_to :timers
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @timer = Timer.find(params[:id])
    @timer.destroy
    flash[:notice] = "Successfully destroyed timer."
    redirect_to timers_url
  end
  
  protected
  def get_collections
    @projects = current_company.projects.all(:include => [:client])
  end
end