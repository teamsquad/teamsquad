class CompetitionController < ApplicationController

  def index
  end
  
  def new
    @titles << 'New competition'
    @form  = Competition.new(@params[:form])
    @form.season_id = @organisation.current_season.id
    if @request.post? and @form.save
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
    if @request.post? && @form.update_attributes(@params["form"])
      redirect_to competition_url(:competition => @form) and return
    end
  end
  
  def fixtures
    get_competition
    @stages = @competition.stages
    @titles << "Fixtures"
  end

  def results
    get_competition
    @stages = @competition.stages
    @titles << "Results"
  end

end
