class OrganisationController < AbstractAccountController

  before_filter :check_logged_in, :only => :edit

  def home
    @new_notices  = @organisation.recent_notices
    @old_notices  = @organisation.older_notices
    @titles      << "Welcome"
  end
  
  def login
    @titles << "Please login"
    if request.post? and attempt_login
      redirect_to(session[:login_to] || home_url) and return
    end
  end
  
  def logout
    reset_session
    redirect_to login_url and return
  end
  
  def edit
    @form = @organisation
    if request.post? && @form.update_attributes(params[:form])
      redirect_to home_url 
    end
  end
  
  def live_search
    get_season
    @teams = @organisation.teams.find(:all, :conditions => ["title ilike ?", "%#{params[:term]}%"])
    @competitions = @season.competitions.find(:all, :conditions => ["title ilike ?", "%#{params[:term]}%"])
    @pages = @organisation.pages.find(:all, :conditions => ["title ilike ?", "%#{params[:term]}%"])
    @notices = @organisation.notices.find(:all, :conditions => ["heading ilike ?", "%#{params[:term]}%"])
    render :action => 'live_search', :layout => false 
  end

end
