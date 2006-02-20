class Public::CompetitionController < PublicController
  
  before_filter :get_competition
  
  def overview
		@stage = @competition.current_stage
		@groups_with_results  = @stage.groups_with_results unless @stage.nil?
		@groups_with_fixtures = @stage.groups_with_fixtures unless @stage.nil?
	end
	
	def fixtures
		@stages = @competition.stages
		@title = "#{@title} - Fixtures"
	end
	
	def results
		@stages = @competition.stages
		@title = "#{@title} - Results"
	end

end
