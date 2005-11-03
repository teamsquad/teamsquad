class MainController < ApplicationController
	
	layout "layouts/main", :except => :live_search

	# ORGANISATION RELATED

	def home
	  throw404 and return unless get_season
		@competitions = @season.competitions
		@new_notices = @organisation.recent_notices
		@old_notices = @organisation.older_notices
	end
		
	def login
		render_text 'Not implemented' and return
	end
	
	def admin
		render_text 'Not implemented' and return
	end
	
	def search
		throw404 and return unless get_season
		perform_search
	end
	
	def live_search
	  throw404 and return unless get_season
	  perform_search
	end
	
	def information
	  throw404 and return unless get_organisation
		@pages = @organisation.pages
		if @params["page_slug"]
			@page  = @pages.collect.find { |page| page.to_param == @params["page_slug"].downcase }
			throw404 and return unless @page
			@title += " - #{@page.title}"
			@heading = @page.title
			@content = @page.content
			@picture = @page.picture
			@main    = false
		else
			@title   += ' - Information'
			@heading = 'Information'
			@content = @organisation.summary
			@picture = false
			@main    = true
		end
	end
	
	def new_page
	  throw404 and return unless get_organisation
	  @title = "#{@title} - Add page"
		@page = Page.new()
		@page.organisation_id = @organisation.id
		if @request.post? and @page.save_from_params(@params[:page])
		  redirect_to :action => 'information', :page_slug => @page and return
		end
	end
	
	def edit_page
	  throw404 and return unless get_organisation
		@page = @organisation.find_page_by_url_slug @params["page_slug"]
		throw404 and return unless @page
		@title = "#{@title} - #{@page.title}"
		if @request.post? and @page.save_from_params(@params[:page])
			redirect_to :action => 'information', :page_slug => @page and return
		end
	end
	
	def notices
	  throw404 and return unless get_organisation
		@notices = @organisation.notices
		@title = "#{@title} - Notices"
	end
	
	def notice
	  throw404 and return unless get_organisation
		@notice  = @organisation.find_notice_by_url_slug @params["page_slug"]
		throw404 and return unless @notice
		@title = "#{@title} - #{@notice.heading}"
		@comments = @notice.comments
		@comment = Comment.new @params["comment"]
		@comment.notice_id = @notice.id
		if @request.post? && @comment.save
			redirect_to :action => 'commented' and return
		end
		@notices = @organisation.recent_notices
	end
	
	def commented
	  throw404 and return unless get_organisation
		@notice  = @organisation.find_notice_by_url_slug @params["page_slug"]
		throw404 and return unless @notice
		@title = "#{@title} - Thanks for the commment"
	end
	
	def new_notice
	  throw404 and return unless get_organisation
	  @title = "#{@title} - Add notice"
		@notice = Notice.new()
		@notice.user_id = 1 # TODO: should be current logged in user
		@notice.organisation_id = @organisation.id
		if @request.post? and @notice.save_from_params(@params[:notice])
		  redirect_to :action => 'home' and return
		end
	end
	
	def edit_notice
	  throw404 and return unless get_organisation
		@notice = @organisation.find_notice_by_url_slug @params["page_slug"]
		throw404 and return unless @notice
		@title = "#{@title} - #{@notice.heading}"
		if @request.post? and @notice.save_from_params(@params[:notice])
		  redirect_to :action => 'notice', :page_slug => @notice and return
		end
	end
	
	def edit_comments
	  throw404 and return unless get_organisation
		@notice = @organisation.find_notice_by_url_slug @params["page_slug"]
		throw404 and return unless @notice
		@title = "#{@title} - #{@notice.heading}"
		@comments = @notice.comments
		if @request.post? and @notice.moderate_comments(params)
			redirect_to :action => 'notices' and return
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
		@stage = @competition.current_stage
		@groups_with_results  = @stage.groups_with_results unless @stage.nil?
		@groups_with_fixtures = @stage.groups_with_fixtures unless @stage.nil?
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
		@stages = @competition.stages
		@title = "#{@title} - Results"
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
	
	# TODO: remove update froms action, place in mode, and do in transaction (as below)
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
	
	# TODO: remove update froms action, place in mode, and do in transaction (as above)
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
		end
		@scripts << 'fixtures'
		@teams_in_group = @group.teams
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
	
	# PRIVATE STUFF
	
	private
	
	  def perform_search
  	  @teams = @organisation.teams.find(:all, :conditions => ["title ilike ?", "#{@params[:term]}%"])
      @competitions = @season.competitions.find(:all, :conditions => ["title ilike ?", "#{@params[:term]}%"])
      @pages = @organisation.pages.find(:all, :conditions => ["title ilike ?", "#{@params[:term]}%"])
      @notices = @organisation.notices.find(:all, :conditions => ["heading ilike ?", "#{@params[:term]}%"])
	  end
end
