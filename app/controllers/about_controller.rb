class AboutController < ApplicationController
  layout 'info'
  skip_before_filter :login_required
  def index
  end

end
