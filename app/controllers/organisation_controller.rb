class OrganisationController < AbstractAccountController

  before_filter :check_logged_in, :only => :edit

  def index
    @new_notices  = @organisation.recent_notices
    get_season
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
    @teams = @organisation.teams.where(["title ilike ?", "%#{params[:term]}%"])
    @competitions = @season.competitions.where(["title ilike ?", "%#{params[:term]}%"])
    @pages = @organisation.pages.where(["title ilike ?", "%#{params[:term]}%"])
    @notices = @organisation.notices.where(["heading ilike ?", "%#{params[:term]}%"])
    render :action => 'live_search', :layout => false 
  end
  
  def venue
    @titles << "Venues"
    @titles << "The REC"
  end

end
