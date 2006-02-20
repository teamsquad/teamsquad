class Private::SeasonController < PrivateController
  
  before_filter :get_season
  
  def new_competition
	  @title = "#{@title} - New competition"
		@competition = Competition.new(@params["competition"])
		@competition.season_id = @season.id
		if @request.post? and @competition.save_with_format
			redirect_to(:controller => '/public/competition', :action => 'overview', :competition_slug => @competition) and return
		end
	end
	
end
