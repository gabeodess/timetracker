class Clients::InvoicesController < ApplicationController
  filter_resource_access :nested_in => :clients
  
  def index
    @invoices = @client.invoices.paginate(:page => params[:id], :order => "created_at DESC")
  end
  
end