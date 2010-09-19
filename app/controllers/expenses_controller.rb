class ExpensesController < ApplicationController
  
  filter_resource_access
  
  def index
    @expenses = Expense.paginate(:page => params[:page])
  end
  
  def show
    @expense = Expense.find(params[:id])
  end
    
  def create
    @expense = Expense.new(params[:expense])
    if @expense.save
      flash[:notice] = "Successfully created expense."
      redirect_to @expense.project
    else
      render :action => 'new'
    end
  end
  
  def edit
    @expense = Expense.find(params[:id])
  end
  
  def update
    @expense = Expense.find(params[:id])
    if @expense.update_attributes(params[:expense])
      flash[:notice] = "Successfully updated expense."
      redirect_to @expense
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    flash[:notice] = "Successfully destroyed expense."
    redirect_to expenses_url
  end
end
