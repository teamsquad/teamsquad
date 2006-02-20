class Private::TeamController < PrivateController
  
  before_filter :get_team
  
  def edit
		if @request.post? && @team.update_attributes(@params["team"])
      redirect_to :action => 'teams' and return
		end
	end
  
end
