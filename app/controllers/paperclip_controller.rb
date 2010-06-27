class PaperclipController < ApplicationController
  
  def destroy
    params[:class_name].constantize.find(params[:id]).update_attributes!(params[:attachment] => nil)
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js   { render :nothing => true }
    end
  end
  
end
