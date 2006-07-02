class OrganisationController < AbstractAccountController

  def home
    @new_notices  = @organisation.recent_notices
    @old_notices  = @organisation.older_notices
    @titles      << "Home"
  end
  
  def login
    if request.post? and attempt_login
      redirect_to home_url and return
    end
  end
  
  def logout
    reset_session
    redirect_to login_url and return
  end

end
