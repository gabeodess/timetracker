class CurrentCompanyController < ApplicationController
  
  def index
    @company = current_company
    respond_to do |format|
      format.html   { render('companies/show') }
      format.mobile { render('companies/show') }
    end
  end

end
