class Public::StageController < PublicController
  
  before_filter :get_stage
    
  def overview
		@stages  = @competition.stages
		@stage_partial = @stage.is_knockout ? 'partials/knockout' : 'partials/table'
	end
	
	protected
	
	def default_url_options(options)
    {
      :stage_slug => @stage,
      :competition_slug => @competition
    }
  end

end
