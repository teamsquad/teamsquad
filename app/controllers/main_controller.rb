class MainController < ApplicationController
	
	layout "layouts/main"

	# ORGANISATION RELATED

	def home
	  throw404 and return unless get_season
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
	  throw404 and return unless get_season
		@notices = @organisation.notices
		@title = "#{@title} - Notices"
	end
	
	def notice
	  throw404 and return unless get_season
		@notice  = @organisation.find_notice_by_url_slug @params["page_slug"]
		throw404 and return unless @notice
		@title = "#{@title} - #{@notice.heading}"
		@comments = @notice.comments
		@comment = Comment.new @params["comment"]
		@comment.notice_id = @notice.id
		if @request.post? && @comment.save
			redirect_to :action => 'commented' and return
		else
			@notices = @organisation.notices(:all, :limit => 5)
			render 'main/notice' and return
		end
	end
	
	def commented
	  throw404 and return unless get_season
		@notice  = @organisation.find_notice_by_url_slug @params["page_slug"]
		throw404 and return unless @notice
		@title = "#{@title} - Thanks for the commment"
	end
	
	def new_notice
	  throw404 and return unless get_season
	  @title = "#{@title} - Add notice"
		@notice = Notice.new()
		@notice.user_id = 1 # TODO: should be current logged in user
		if @request.post?
			@notice.root_path = RAILS_ROOT
			@notice.heading = @params["notice"]["heading"]
			@notice.content = @params["notice"]["content"]
			@notice.upload  = @params["notice"]["picture"]
			@notice.organisation_id = @organisation.id
			if @notice.save
				redirect_to :action => 'home' and return
			end
		end
	end
	
	def edit_notice
	  throw404 and return unless get_season
		@notice = @organisation.find_notice_by_url_slug @params["page_slug"]
		throw404 and return unless @notice
		@title = "#{@title} - #{notice.heading}"
		if @request.post?
			@notice.heading = @params["notice"]["heading"]
			@notice.content = @params["notice"]["content"]
			@notice.upload  = @params["notice"]["picture"]
			if @notice.save
				redirect_to :action => 'notices' and return
			end
		end
	end
	
	# TEAM RELATED
	
	def teams
	  throw404 and return unless get_organisation
		@teams = @organisation.teams
		@title = "#{@title} - Teams"
	end
	
	def team
		throw404 and return unless get_team
	end
	
	def new_team
	  throw404 and return unless get_organisation
	  @title = "#{@title} - Add team"
		@team = Team.new(@params["team"])
		@team.organisation_id = @organisation.id
		if @request.post? and @team.save
			redirect_to :action => 'teams' and return
		end
	end
	
	def edit_team
		throw404 and return unless get_team
		if @request.post? && @team.update_attributes(@params["team"])
      redirect_to :action => 'teams' and return
		end
	end
	
	# COMPETITION RELATED
	
	def competition
		throw404 and return unless get_competition
		@stages = @competition.stages
	end
	
	def new_competition
	  throw404 and return unless get_season
	  @title = "#{@title} - Add competition"
		@competition = Competition.new(@params["competition"])
		@competition.season_id = @season.id
		if @request.post? and @competition.save_with_format
			redirect_to(:action => 'competition', :competition_slug => @competition) and return
		end
	end
	
	def edit_competition
		throw404 and return unless get_competition
		if @request.post? && @competition.update_attributes(@params["competition"])
			redirect_to(:action => 'competition', :competition_slug => @competition) and return
		end
	end
	
	def fixtures
		throw404 and return unless get_competition
		@stages = @competition.stages
		@title = "#{@title} - Fixtures"
	end
	
	def results
		throw404 and return unless get_competition
		@title = "#{@title} - Results"
		@stages = @competition.stages
	end
	
	def enter_results
	  throw404 and return unless get_group
	  @title = "#{@title} - Enter results"
    @games = @group.outstanding_results
    @stages = @competition.stages
    if request.post? and @competition.process_results(@params)
			redirect_to :action => 'results' and return
		end
	end
	
	# STAGE RELATED
	
	def stage
		throw404 and return unless get_stage
		@stages  = @competition.stages
		@stage_partial = @stage.is_knockout ? 'partials/knockout' : 'partials/table'
	end
	
	def new_stage
		throw404 and return unless get_competition
		@title = "#{@title} - Add stage"
		@stage = Stage.new(params["stage"])
		@stage.competition_id = @competition.id
		if @request.post? and @stage.save
			redirect_to(
			  :action => 'stage',
			  :competition_slug => @competition,
			  :stage_slug => @stage
			) and return
		end
	end
	
	def edit_stage
		throw404 and return unless get_stage
		@title = "#{@title} - Edit stage"
		if @request.post? && @stage.update_attributes(@params["stage"])
			redirect_to(
			  :action => 'stage',
			  :competition_slug => @competition,
			  :stage_slug => @stage
			) and return
		end
	end
	
	# GROUP RELATED
	
	def new_group
		throw404 and return unless get_stage
		@title = "#{@title} - Add group"
		@group = Group.new(params["group"])
		@group.stage_id = @stage.id
		if @request.post? and @group.save
			redirect_to(:action => 'stage') and return
		end
	end
	
	def edit_group
		throw404 and return unless get_group
		@title = "#{@title} - Edit group"
		if @request.post? && @group.update_attributes(@params["group"])
		  redirect_to :action => 'stage' and return
		end		
	end
	
	def add_teams
		throw404 and return unless get_group
		@teams = @organisation.teams
		@teams = @teams - @group.teams
		@title = "#{@title} - Add teams"
		if @request.post? && @params[:teams]
  		for id in @params[:teams]
  			team = @organisation.teams.find(id)
  			@group.teams << team unless team.nil?
  		end
			redirect_to :action => 'stage' and return
		end
	end
	
	def remove_teams
		throw404 and return unless get_group
		@teams = @group.teams
		@title = "#{@title} - Remove teams"
		if @request.post? && @params[:teams]
		  for id in @params[:teams]
				team = @group.teams.find(id)
				@group.remove_team!(team) unless team.nil?
			end
			redirect_to :action => 'stage' and return
		end
	end
	
	def new_fixtures
		throw404 and return unless get_group
		@title = "#{@title} - Add fixtures"
		if @request.post? and @group.process_fixtures(@params)
			redirect_to :action => 'stage' and return
		else
		  @scripts << 'fixtures'
			@teams_in_group = @group.teams
		end
	end
	
	def edit_fixture
	  throw404 and return unless get_group
	  @title = "#{@title} - Edit fixture"
	  @game = Game.find @params[:id]
	  throw404 and return unless @game
	  @teams_in_group = @group.teams
	  @team_options = @teams_in_group.collect { |team| [team.title, team.id] } 
	  if @params[:kickoff]
	    @params[:game][:kickoff] = "{@params[:kickoff][:year]}-{@params[:kickoff][:month]}-{@params[:kickoff][:day]} {@params[:kickoff][:hour]}:{@params[:kickoff][:minutes]}:00"
	  end
	  if @request.post? and @game.update_attributes(@params[:game])
	    redirect_to :action => 'fixtures' and return
	  end
	end
end
