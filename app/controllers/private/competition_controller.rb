class Private::CompetitionController < Private::AbstractController
  
  before_filter :get_competition
  
	def edit
		if @request.post? && @competition.update_attributes(@params["competition"])
			redirect_to(:controller => '/public/competition', :action => 'overview', :competition_slug => @competition) and return
		end
	end  

	def new_stage
		@title = "#{@title} - New stage"
		@stage = Stage.new(params["stage"])
		@stage.competition_id = @competition.id
		if @request.post? and @stage.save
			redirect_to(
			  :controller => '/public/stage', 
			  :action => 'overview',
			  :competition_slug => @competition,
			  :stage_slug => @stage
			) and return
		end
	end
	
	protected

	def default_url_options(options)
    {
      :competition_slug => @competition
    }
  end

end
