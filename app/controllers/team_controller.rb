class TeamController < AbstractAccountController
  
  before_filter :check_logged_in, :only => [:new, :edit]
  
  def index
    @titles << @organisation.teams_or_players.capitalize
    @teams = @organisation.teams
  end
  
  def new
    @titles << "New #{@organisation.team_or_player}"
    @form  = Team.new(params[:form])
    @form.organisation_id = @organisation.id
    if request.post? and @form.save
      redirect_to teams_url and return
    end
  end
  
  def view
    get_team
  end
  
  def edit
    get_team
    @titles << "Edit #{@organisation.team_or_player}"
    @form = @team
    if request.post? && @form.update_attributes(params["form"])
      redirect_to team_url(:team => @team) and return
    end
  end
  
  def fixtures
    get_team
    @titles << "Fixtures"
  end
  
  def results
    get_team
    @titles << "Results"
  end

end
