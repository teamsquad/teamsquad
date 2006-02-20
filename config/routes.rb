ActionController::Routing::Routes.draw do |map|
  # First created -> highest priority.
  
  map.home  '',
		:controller => 'public/season',
		:action => 'home',
		:defaults => {
		  :competition_slug => nil,
		  :stage_slug => nil,
		}

  #
  # ORGANISATION
  #
  
  
  map.organisation ':action/:slug',
    :controller => 'public/organisation',
    :action => /^(login|search|live_search|teams|notices|notice|commented|information)$/,
    :slug => nil
    
  map.organisation_admin ':action/:slug',
    :controller => 'private/organisation',
    :action => /^(new_team|new_competition|new_page|new_notice|edit_page|edit_notice|edit_comments)$/,
		:slug => nil
		
		
  #
  # TEAM
  #

	map.team	'teams/:id/:action',
  	:controller => 'public/team',
  	:action => /^(overview|fixtures|results)$/,
  	:defaults => {
  	  :action => 'overview'
  	}

	map.team_admin	'teams/:id/:action',
		:controller => 'private/team',
		:action => /^(edit)$/

	#
  # COMPETITION
  #
  
  map.competition	':competition_slug/:action',
		:controller => 'public/competition',
		:action => /^(overview|results|fixtures)$/,
		:defaults => {:action => 'overview'}
	
	map.competition_admin	':competition_slug/:action',
		:controller => 'private/competition',
		:action => /^(edit|new_stage)$/

  #
  # STAGE
  #
  
  map.stage ':competition_slug/:stage_slug',
		:controller => 'public/stage',
		:action => 'overview'	
		
	map.stage_admin ':competition_slug/:stage_slug/:action',
		:controller => 'private/stage',
		:action => /^(edit|new_group)$/
		
  #
  # GROUP
  #
  
  map.group ':competition_slug/:stage_slug/:group_slug/:action',
		:controller => 'public/group',
		:action => /^(nothing|yet|public)$/

  map.group_admin ':competition_slug/:stage_slug/:group_slug/:action/:id',
		:controller => 'private/group',
		:action => /^(edit|edit_fixture|add_teams|remove_teams|new_fixtures|enter_results)$/,
		:id => nil

end
