class TeamController < AbstractAccountController
  
  def index
    @titles << 'Teams'
    @teams = @organisation.teams
  end
  
  def new
    @titles << 'New team'
    @form  = Team.new(@params[:form])
    @form.organisation_id = @organisation.id
    if @request.post? and @form.save
      redirect_to teams_url and return
    end
  end
  
  def view
    get_team
  end
  
  def edit
    get_team
    @titles << 'Edit Team'
    @form = @team
    if @request.post? && @form.update_attributes(@params["form"])
      redirect_to team_url(:competition => @form) and return
    end
  end

end
