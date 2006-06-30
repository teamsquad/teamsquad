class GroupController < ApplicationController
  
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
      redirect_to stage_url(:competition => @competition, :stage => @stage) and return
    end
  end
  
  def new_fixtures
    get_group
    @titles << "New fixtures"
    if @request.post? and @group.process_fixtures(@params)
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
      redirect_to competition_url(:competition => @competition) and return
    end
  end

end
