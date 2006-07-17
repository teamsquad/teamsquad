class StageController < AbstractAccountController
  
  def new
    get_competition
    @titles << "New stage"
    @form = Stage.new(params["form"])
    @form.competition_id = @competition.id
    if request.post? and @form.save
      redirect_to stage_url(:competition => @competition, :stage => @form) and return
    end
  end
  
  def view
    get_stage
    @titles << @stage.title unless @competition.stages_count > 1
    @stages  = @competition.stages
    @stage_partial = @stage.is_knockout ? 'partials/knockout' : 'partials/table'
  end
  
  def edit
    get_stage
    @titles << "Edit"
    @form = @stage
    if request.post? && @form.update_attributes(params["form"])
      redirect_to stage_url(:competition => @competition, :stage => @form) and return
    end
  end

end
