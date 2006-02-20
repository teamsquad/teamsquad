# The methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	
	def safely_display(source)
		result = source
		simple_format(auto_link(CGI.escapeHTML(result))) 
	end
	
	# LINKS
	# Doing this rather than named routes to save repeating lots of arguments
	# each and every time one is called. For example: on a stage page any link
	# to a competition page using a named route (xxx_url) seems to pass in
	# the stage_slug param even though the competition rotues don't use it.
	# To avoid this have to manually set it to nil - every bloody time!
	
	def competition_link(competition=nil, action=nil)
	  url_for(
	    :controller => '/public/competition',
	    :competition_slug => competition.to_param,
	    :stage_slug => nil,
	    :action => action
	  )
	end
	
	def competition_admin_link(competition=nil, action=nil)
	  url_for(
	    :controller => '/private/competition',
	    :competition_slug => competition.to_param,
	    :stage_slug => nil,
	    :action => action
	  )
	end
	
	def stage_link(stage=nil, action=nil)
	  url_for(
	    :controller => '/public/stage',
	    :competition_slug => stage.competition.to_param,
	    :stage_slug => stage.to_param,
	    :action => action
	  )
	end
	
	def stage_admin_link(stage=nil, action=nil)
	  url_for(
	    :controller => '/private/stage',
	    :competition_slug => stage.competition.to_param,
	    :stage_slug => stage.to_param,
	    :action => action	  
	  )
  end
  
	def group_link(group=nil, action=nil)
	  url_for(
	    :controller => '/public/group',
	    :competition_slug => group.stage.competition.to_param,
	    :stage_slug => group.stage.to_param,
	    :group_slug => group.to_param,
	    :action => action
	  )
	end
	
	def group_admin_link(group=nil, action=nil)
	  url_for(
	    :controller => '/private/group',
	    :competition_slug => group.stage.competition.to_param,
	    :stage_slug => group.stage.to_param,
	    :group_slug => group.to_param,
	    :action => action	  
	  )
  end

end
