class Private::GroupController < Private::AbstractController
  
  before_filter :get_group
  
  def edit
		@title = "#{@title} - Edit"
		if @request.post? && @group.update_attributes(@params["group"])
		  redirect_to :controller => '/public/stage', :action => 'overview' and return
		end		
	end
  
  def enter_results
	  @title = "#{@title} - Enter results"
    @games = @group.outstanding_results
    @stages = @competition.stages
    if request.post? and @competition.process_results(@params)
			redirect_to :controller => '/public/competition', :action => 'results' and return
		end
	end
	
	def add_teams
		@teams = @organisation.teams
		@teams = @teams - @group.teams
		@title = "#{@title} - Add teams"
		if @request.post? && @params[:teams]
  		for id in @params[:teams]
  			team = @organisation.teams.find(id)
  			@group.teams << team unless team.nil?
  		end
			redirect_to :controller => '/public/stage', :action => 'overview' and return
		end
	end
	
	def remove_teams
		@teams = @group.teams
		@title = "#{@title} - Remove teams"
		if @request.post? && @params[:teams]
		  for id in @params[:teams]
				team = @group.teams.find(id)
				@group.remove_team!(team) unless team.nil?
			end
			redirect_to :controller => '/public/stage', :action => 'overview' and return
		end
	end
	
	def new_fixtures
		@title = "#{@title} - New fixtures"
		if @request.post? and @group.process_fixtures(@params)
			redirect_to :controller => '/public/stage', :action => 'overview' and return
		end
		@scripts << 'fixtures'
		@teams_in_group = @group.teams
	end
	
	def edit_fixture
	  @title = "#{@title} - Edit fixture"
	  @game = Game.find @params[:id]
	  throw404 and return unless @game
	  @teams_in_group = @group.teams
	  @team_options = @teams_in_group.collect { |team| [team.title, team.id] } 
	  if @params[:kickoff]
	    @params[:game][:kickoff] = "{@params[:kickoff][:year]}-{@params[:kickoff][:month]}-{@params[:kickoff][:day]} {@params[:kickoff][:hour]}:{@params[:kickoff][:minutes]}:00"
	  end
	  if @request.post? and @game.update_attributes(@params[:game])
	    redirect_to :controller => '/public/competition', :action => 'fixtures' and return
	  end
	end
	
	protected

	def default_url_options(options)
    {
      :competition_slug => @competition,
      :stage_slug => @stage,
      :group_slug => @group
    }
  end
	
end
