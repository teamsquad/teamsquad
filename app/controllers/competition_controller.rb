class CompetitionController < AbstractAccountController

  before_filter :check_logged_in, :only => [:new, :edit]

  def index
    @titles << 'Competitions'
    @competitions = @organisation.current_season.competitions
  end
  
  def new
    @titles << 'New competition'
    @form  = Competition.new(params[:form])
    @form.season_id = @organisation.current_season.id
    if request.post? and @form.save
      redirect_to competition_url(:competition => @form) and return
    end
  end
  
  def view
    get_competition
    @stage = @competition.current_stage
  end

  def edit
    get_competition
    @titles << 'Edit competition'
    @form = @competition
    if request.post? && @form.update_attributes(params["form"])
      redirect_to competition_url(:competition => @form) and return
    end
  end
  
  def fixtures
    get_competition
    unless read_fragment(:action => :fixtures)
      @days = @competition.fixtures.group_by(&:yyyymmdd).sort
    end
    @stages = @competition.stages
    @titles << "Fixtures"
  end
  
  def add_fixtures
    get_competition
    stage = @competition.current_stage
    group = stage.groups.first
    redirect_to new_fixtures_url(:competition => @competition, :stage => stage, :group => group)
  end

  def results
    get_competition
    unless read_fragment(:action => :results)
      @days = @competition.results.group_by(&:yyyymmdd).sort
    end
    @stages = @competition.stages
    @titles << "Results"
  end

end
