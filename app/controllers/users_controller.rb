class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  skip_before_filter :login_required, :only => [:new, :create]
  skip_before_filter :company_login_required
  filter_resource_access
  
  def show
    @user = User.find_by_login(params[:id])
  end

  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_back_or_default(@user)
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Your account has been updated."
      redirect_to @user
    else
      render :edit
    end
  end
  
  protected
    def load_user
      @user = User.find_by_login(params[:id])
    end
  
end
