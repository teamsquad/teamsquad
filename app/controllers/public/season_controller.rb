class Public::SeasonController < PublicController
  
  before_filter :get_season
  
  def home
		@competitions = @season.competitions
		@new_notices = @organisation.recent_notices
		@old_notices = @organisation.older_notices
	end
  
  def search
		perform_search
	end
	
	def live_search
	  perform_search
	  render :layout => false
	end
	
	# PRIVATE STUFF
	
	private
	
	  def perform_search
  	  @teams = @organisation.teams.find(:all, :conditions => ["title ilike ?", "#{@params[:term]}%"])
      @competitions = @season.competitions.find(:all, :conditions => ["title ilike ?", "#{@params[:term]}%"])
      @pages = @organisation.pages.find(:all, :conditions => ["title ilike ?", "#{@params[:term]}%"])
      @notices = @organisation.notices.find(:all, :conditions => ["heading ilike ?", "#{@params[:term]}%"])
	  end
	
end
