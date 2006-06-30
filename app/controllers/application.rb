# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  
  layout 'main'
  
  helper_method :current_user, :authorised?
  
  before_filter :init, :get_organisation

protected

  def init
    expires_now # Set HTTP header to avoid caching of pages
    @titles  = []
    @scripts = []
  end
  
  # Filters that can be called by the various controllers...

  def get_organisation
    @organisation = Organisation.find_by_nickname(request.subdomains.first)
    @titles << @organisation.title if @organisation
    @organisation or (throw404 and return false)
  end

  def get_team
    (throw404 and return false) unless @organisation
    @team = @organisation.find_team(@params["team"])
    @titles <<  @team.title if @team
    @team or (throw404 and return false)
  end
  
  def get_season
    (throw404 and return false) unless @organisation
    @season = @organisation.current_season
    @season or (throw404 and return false)
  end
  
  def get_competition
    (throw404 and return false) unless get_season
    @competition = @season.find_competition(@params["competition"])
    @titles << @competition.title if @competition
    @competition or (throw404 and return false)
  end
  
  def get_stage
    (throw404 and return false) unless get_competition
    @stage = @competition.find_stage(@params["stage"])
    @titles << @stage.title unless @stage.nil? or @competition.stages.count == 1
    @stage or (throw404 and return false)
  end
  
  def get_group
    (throw404 and return false) unless get_stage
    @group = @stage.find_group(@params["group"])
    @group or (throw404 and return false)
  end
  
  def get_notice
    (throw404 and return false) unless @organisation
    @notice = @organisation.find_notice(@params["notice"]) unless @organisation.nil?
    @titles << @notice.heading if @notice
    @notice or (throw404 and return false)
  end
  
  def throw404
    redirect_to('/404.html')
  end
  
  protected

  # Returns the currently logged in user or false if none found.
  # Note the user isn't stored in the session, only their id.
  # This saves memory and also means if user model is changed it still works.
  def current_user
    return false unless session[:user_id] 
    @current_user ||= User.find( session[:user_id] )
  end
  
  def check_logged_in
    return current_user if current_user
    redirect_to login_url and return false 
  end
  
  def authorised?
    current_user ? true : false
  end

  def attempt_login
    user = User.login(params[:email], params[:password])
    if user
      session[:user_id] = user.id
    else
      false
    end
  end

end