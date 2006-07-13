class GroupController < AbstractAccountController

  before_filter :check_logged_in
  before_filter :get_stage
  
  def new
    @titles << "New group"
    @form = Group.new(params["form"])
    @form.stage_id = @stage.id
    @teams = @organisation.teams
    if @request.post? and @form.save
      redirect_to stage_url(:competition => @competition, :stage => @stage) and return
    end
  end

  def edit
    get_group
    @titles << "Edit"
    @form = @group
    @teams = @organisation.teams
    # If no teams are selected the team_ids param never comes in so
    # nothing happens when we call update_attributes. So, to get
    # round this we manually set team_ids to an empty array if it
    # is missing from request. This mean unselecting each team checkbox
    # will remove all teams (just like it should!).
    @params[:form] && @params[:form][:team_ids] ||= []
    if @request.post? && @form.update_attributes(@params["form"])
      clear_caches
      redirect_to stage_url(:competition => @competition, :stage => @stage) and return
    end
  end
  
  def new_fixtures
    get_group
    @titles << "New fixtures"
    if @request.post? and @group.process_fixtures(@params)
      clear_caches(params[:when])
      redirect_to stage_url(:competition => @competition, :stage => @stage) and return
    end
    @scripts << 'fixtures'
    @teams_in_group = @group.teams
  end
  
  def enter_results
    get_group
    @titles << "Enter results"
    @games = @group.overdue_fixtures
    @stages = @competition.stages
    if request.post? and @competition.process_results(@params)
      clear_caches
      redirect_to competition_url(:competition => @competition) and return
    end
  end
  
private

  def clear_caches(date = nil)
    expire_fragment(:controller => 'competition', :action => "fixtures")
    expire_fragment(:controller => 'competition', :action => "results")
    expire_fragment(:controller => 'team', :action => "fixtures")
    expire_fragment(:controller => 'team', :action => "results")
    expire_fragment(:controller => 'competition', :action => "view")
    expire_fragment(:controller => 'calendar', :action => "index")
    if date
      expire_fragment(:controller => 'calendar', :action => "year", :year => date[:year])
      expire_fragment(:controller => 'calendar', :action => "month", :year => date[:year], :month => date[:month])
      expire_fragment(:controller => 'calendar', :action => "day", :year => date[:year], :month => date[:month], :day => date[:day])
    end
  end

end
