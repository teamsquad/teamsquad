# The filters added to this controller will be run for all controllers in the application.
# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
	
	before_filter :init

	protected

	def init
		@title   = "TeamSquad"
		@scripts = Array.new
	end
	
	def get_organisation
		@organisation = Organisation.find_by_url_slug(request.subdomains.first)	
		if @organisation then @sport = @organisation.sport end
		did_we_find? @organisation
	end
	
	def get_team
		@team = @organisation.find_team_by_url_slug @params["team_slug"]
		did_we_find? @team			
	end
	
	def get_current_season
		get_organisation
		@season = @organisation.current_season
		did_we_find? @season
	end
	
	def get_competition
		@competition = @season.find_competition_by_url_slug @params["competition_slug"]
		@other_competitions = @season.competitions.find :all, :conditions => ["id!=?" ,@competition.id]
	  did_we_find? @competition
	end
	
	def get_stage
		if get_competition
		 @stage = @competition.find_stage_by_url_slug @params["stage_slug"]
		end
		did_we_find? @stage
	end
	
	def get_group
		if get_stage
		  @group = @stage.find_group_by_url_slug @params["group_slug"]
		end
		did_we_find? @group
	end
	
	private
	
	def did_we_find?(thing)
	  if thing.respond_to? :title then @title += " - #{thing.title}" end 
		!(thing.nil? && redirect_to("/404.html"))
	end
	
end