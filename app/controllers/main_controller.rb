class MainController < ApplicationController
	
	layout "layouts/main"
	
	before_filter :get_current_season
	
	# ORGANISATION RELATED

	def home
		@competitions = @season.competitions
		@new_notices = @organisation.notices.find(:all, :limit => 2, :include => :author)
		@old_notices = @organisation.notices.find(:all, :offset => 2, :limit => 5, :include => :author)
	end
		
	def login
		
	end
	
	def admin
		
	end
	
	def search
		
	end
	
	def notices
		@notices = @organisation.notices
	end
	
	def notice
		@notice  = @organisation.find_notice_by_url_slug @params["page_slug"]
		@comments = @notice.comments
		@comment = Comment.new @params["comment"]
		@comment.notice_id = @notice.id
		if @request.post? && @comment.save
			redirect_to :action => 'commented'
		else
			@notices = @organisation.notices(:all, :limit => 5)
			render 'main/notice'
		end
	end
	
	def commented
		@notice  = @organisation.find_notice_by_url_slug @params["page_slug"]
	end
	
	def new_notice
		@notice = Notice.new()
		@notice.user_id = 1 # TODO: should be current logged in user
		if @request.post?
			@notice.root_path = RAILS_ROOT
			@notice.heading = @params["notice"]["heading"]
			@notice.content = @params["notice"]["content"]
			@notice.upload  = @params["notice"]["picture"]
			@notice.organisation_id = @organisation.id
			if @notice.save
				redirect_to :action => 'home'
			end
		end
	end
	
	def edit_notice
		@notice = @organisation.find_notice_by_url_slug @params["page_slug"]
		if @request.post?
			@notice.heading = @params["notice"]["heading"]
			@notice.content = @params["notice"]["content"]
			@notice.upload  = @params["notice"]["picture"]
			if @notice.save
				redirect_to :action => 'notices'
			end
		end
	end
	
	# TEAM RELATED
	
	def teams
		@teams = @organisation.teams
	end
	
	def team
		get_team
	end
	
	def new_team
		@team = Team.new(@params["team"])
		@team.organisation_id = @organisation.id
		if @request.post? and @team.save
			redirect_to :action => 'teams'
		end
	end
	
	def edit_team
		if get_team
			if @request.post?
				@team.title   = @params["team"]["title"]
				if @team.save
					redirect_to :action => 'teams'
				end
			end
		end
	end
	
	# COMPETITION RELATED
	
	def competition
		if get_competition
			@stages = @competition.stages
		end
	end
	
	def new_competition
		@competition = Competition.new(@params["competition"])
		@competition.season_id = @season.id
		if @request.post? and @competition.save_with_format
			redirect_to :action => 'competition', :competition_slug => @competition
		end
	end
	
	def edit_competition
		if get_competition
			if @request.post?
				@competition.title   = @params["competition"]["title"]
				@competition.summary = @params["competition"]["summary"]
				if @competition.save
					redirect_to :action => 'competition', :competition_slug => @competition
				end
			end
		end
	end
	
	def fixtures
		if get_competition
			@stages = @competition.stages
		end
	end
	
	def results
		if get_competition
			@stages = @competition.stages
		end
	end
	
	def enter_results
	  if get_group
	    @games = @group.outstanding_results
	    @stages = @competition.stages
	    if request.post? and @competition.process_results(@params)
  			redirect_to :action => 'results'
  		end
    end
	end
	
	# STAGE RELATED
	
	def stage
		if get_stage
			@stages  = @competition.stages
			@stage_partial = @stage.is_knockout ? 'partials/knockout' : 'partials/table'
		end
	end
	
	def new_stage
		if get_competition
			@stage = Stage.new(params["stage"])
			@stage.competition_id = @competition.id
			if @request.post? and @stage.save
				redirect_to :action => 'stage', :competition_slug => @competition, :stage_slug => @stage
			end
		end
	end
	
	def edit_stage
		if get_stage
			if @request.post?
				@stage.attributes = @params["stage"]
				if @stage.save
					redirect_to :action => 'stage', :competition_slug => @competition, :stage_slug => @stage
				end
			end
		end
	end
	
	# GROUP RELATED
	
	def new_group
		if get_stage
			@group = Group.new(params["group"])
			@group.stage_id = @stage.id
			if @request.post? and @group.save
				redirect_to :action => 'stage'
			end
		end		
	end
	
	def edit_group
		if get_group
			if @request.post?
				@group.attributes = @params["group"]
				if @group.save
					redirect_to :action => 'stage'
				end
			end
		end		
	end
	
	def add_teams
		if get_group
			@teams = @organisation.teams
			@teams = @teams - @group.teams
			if @request.post?
				if @params[:teams]
					for id in @params[:teams]
						team = @organisation.teams.find id
						@group.teams << team unless team.nil?
					end
				end
				redirect_to :action => 'stage'
			end
		end
	end
	
	def remove_teams
		if get_group
			@teams = @group.teams
			if @request.post?
				if @params[:teams]
					for id in @params[:teams]
						team = @group.teams.find id
						@group.remove_team! team unless team.nil?
					end
				end
				redirect_to :action => 'stage'
			end
		end
	end
	
	def new_fixtures
		if get_group
			if request.get?
				@scripts << 'fixtures'
				@teams_in_group = @group.teams
			end
			if @request.post? and @group.process_fixtures(@params)
				redirect_to :action => 'stage'
			end
		end
	end
	
end
