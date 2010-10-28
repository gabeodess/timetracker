class InvoicesController < ApplicationController
  
  filter_resource_access
  
  def index
    @invoices = current_company.invoices.paginate(:page => params[:page])
  end
  
  def show
    @invoice = current_company.invoices.find(params[:id])
    @info = @invoice.load_info
  end
  
  def new
    @invoice = Invoice.new(params[:invoice])
    @invoice.timers = @invoice.client.uninvoiced_timers
    @invoice.expenses = @invoice.client.expenses
    @invoice.print_receipt#(@invoice.uninvoiced_timers)
  end
  
  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.invoice_emails << current_user.email if @invoice.email_me == '1'
    if @invoice.save
      flash[:notice] = "Successfully created invoice."
      redirect_to @invoice
    else
      render :action => 'new'
    end
  end
  
  def edit
    @invoice = current_company.invoices.find(params[:id])
  end
  
  def update
    @invoice = current_company.invoices.find(params[:id])
    if @invoice.update_attributes(params[:invoice])
      flash[:notice] = "Successfully updated invoice."
      redirect_to params[:return_to] || @invoice
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    # @invoice = Invoice.find(params[:id])
    # @invoice.destroy
    # flash[:notice] = "Successfully destroyed invoice."
    redirect_to @invoice.client
  end
end
