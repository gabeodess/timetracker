class AssigmentsController < ApplicationController
  
  filter_resource_access
  
  def index
    @assigments = Assigment.paginate(:page => params[:page])
  end
  
  def show
    @assigment = Assigment.find(params[:id])
  end
  
  def new
    @assigment = Assigment.new
  end
  
  def create
    @assigment = Assigment.new(params[:assigment])
    if @assigment.save
      flash[:notice] = "Successfully created assigment."
      redirect_to @assigment
    else
      render :action => 'new'
    end
  end
  
  def edit
    @assigment = Assigment.find(params[:id])
  end
  
  def update
    @assigment = Assigment.find(params[:id])
    if @assigment.update_attributes(params[:assigment])
      flash[:notice] = "Successfully updated assigment."
      redirect_to @assigment
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @assigment = Assigment.find(params[:id])
    @assigment.destroy
    flash[:notice] = "Successfully destroyed assigment."
    redirect_to assigments_url
  end
end
