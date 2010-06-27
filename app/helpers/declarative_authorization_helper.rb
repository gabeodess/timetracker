module DeclarativeAuthorizationHelper
  
  def superuser
    logged_in? && current_user.is_superuser
  end
  alias_method :superuser?, :superuser
  
end