# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
	
	layout 'main'
	
	before_filter :init

	protected

	def init
		@title   = "TeamSquad"
		@scripts = Array.new
	end
	
	# Filters that can be called by the various controllers...

	def get_organisation
		@organisation = Organisation.find_by_url_slug(request.subdomains.first)
		@title = @organisation.title if @organisation
		@organisation or false
	end

	def get_team
	  return false unless get_organisation
		@team = @organisation.find_team_by_id(@params["id"])
		@title = "#{@title} - #{@team.title}" if @team
		@team or false
	end
	
	def get_season
	  return false unless get_organisation
		@season = @organisation.current_season
		@season or false
	end
	
	def get_competition
	  return false unless get_season
		@competition = @season.find_competition_by_url_slug(@params["competition_slug"])
		@title = "#{@title} - #{@competition.title}" if @competition
		@competition or false
	end
	
	def get_stage
		return false unless get_competition
		@stage = @competition.find_stage_by_url_slug(@params["stage_slug"])
		@title = "#{@title} - #{@stage.title}" if @stage
		@stage or false
	end
	
	def get_group
		return false unless get_stage
		@group = @stage.find_group_by_url_slug(@params["group_slug"])
		@group or false
	end
	
	def get_notice
	  @notice = @organisation.find_notice_by_url_slug @params["slug"] unless @organisation.nil?
	  @title = "#{@title} - #{@notice.heading}" if @notice
	  @notice or false
  end
	
	def throw404
	  redirect_to('/404.html')
	end

end