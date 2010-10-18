class ClientsController < ApplicationController
  filter_resource_access
  def index
    @clients = current_company.clients.paginate(:page => params[:page])
  end
  
  def show
    @client = Client.find(params[:id], :include => [{:projects => [:timers, :uninvoiced_timers]}])
  end
  
  def new
    @client = Client.new
  end
  
  def create
    @client = Client.new(params[:client])
    @client.company_id = current_company.id
    if @client.save
      flash[:notice] = "Successfully created client."
      redirect_to @client
    else
      render :action => 'new'
    end
  end
  
  def edit
    @client = Client.find(params[:id])
  end
  
  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(params[:client])
      flash[:notice] = "Successfully updated client."
      redirect_to @client
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @client = Client.find(params[:id])
    @client.destroy
    flash[:notice] = "Successfully destroyed client."
    redirect_to :dashboard
  end
  
end
