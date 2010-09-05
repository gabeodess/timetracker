class InvoicesController < ApplicationController
  
  filter_resource_access
  
  def index
    @invoices = Invoice.paginate(:page => params[:page])
  end
  
  def show
    @invoice = Invoice.find(params[:id])
    @info = @invoice.load_info
  end
  
  def new
    @invoice = Invoice.new(params[:invoice])
    @invoice.print_receipt(@invoice.uninvoiced_timers)
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      flash[:notice] = "Successfully created invoice."
      redirect_to @invoice
    else
      render :action => 'new'
    end
  end
  
  def edit
    @invoice = Invoice.find(params[:id])
  end
  
  def update
    @invoice = Invoice.find(params[:id])
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = "Successfully updated invoice."
      redirect_to @invoice
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    flash[:notice] = "Successfully destroyed invoice."
    redirect_to @invoice.client
  end
end
