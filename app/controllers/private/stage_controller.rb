class Private::StageController < Private::AbstractController
  
  before_filter :get_stage
  
  def edit
		@title = "#{@title} - Edit"
		if @request.post? && @stage.update_attributes(@params["stage"])
			redirect_to(
			  :controller => '/public/stage'
			  :action => 'overview',
			  :competition_slug => @competition,
			  :stage_slug => @stage
			) and return
		end
	end

	def new_group
		@title = "#{@title} - New group"
		@group = Group.new(params["group"])
		@group.stage_id = @stage.id
		if @request.post? and @group.save
			redirect_to(:controller => '/public/stage', :action => 'overview') and return
		end
	end
	
	protected

	def default_url_options(options)
    {
      :competition_slug => @competition,
      :stage_slug => @stage
    }
  end

end
