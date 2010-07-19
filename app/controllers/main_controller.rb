class MainController < ApplicationController
  
  def dashboard
    @company = current_company
    render :template => '/companies/show'
  end

end
