ActionController::Routing::Routes.draw do |map|
  # Add your own custom routes here.
  # The priority is based upon order of creation: first created -> highest priority.
  
	map.home  '',
		:controller => 'main',
		:action => 'home'
		
  map.connect ':action/:page_slug',
		:controller => 'main',
		:action => /information|edit_page|edit_notice|edit_comments/,
		:page_slug => nil

	map.connect ':action',
		:controller => 'main',
		:action => /login|admin|search|live_search|teams|notices|new_team|new_competition|new_page|new_notice/
		
	map.connect 'notices/:page_slug',
		:controller => 'main',
		:action => 'notice',
		:page_slug => nil
		
	map.connect 'notices/:page_slug/commented',
		:controller => 'main',
		:action => 'commented'

	map.connect	'teams/:team_slug',
			:controller => 'main',
			:action => 'team'

	map.connect	'teams/:team_slug/:action',
		:controller => 'main',
		:action => /edit_team/

	map.connect	':competition_slug',
		:controller => 'main',
		:action => 'competition'
	
	map.connect	':competition_slug/:action',
		:controller => 'main',
		:action => /edit_competition|results|fixtures|new_stage/
		
	map.connect ':competition_slug/:stage_slug',
		:controller => 'main',
		:action => 'stage'	
		
	map.connect ':competition_slug/:stage_slug/:action',
		:controller => 'main',
		:action => /edit_stage|new_group/
		
	map.connect ':competition_slug/:stage_slug/:group_slug/:action/:team_slug',
		:controller => 'main',
		:action => /edit_group|add_teams|remove_teams|new_fixtures|enter_results/,
		:team_slug => nil

  map.connect ':competition_slug/:stage_slug/:group_slug/:action/:id',
		:controller => 'main',
		:action => /edit_fixture/,
		:id => nil
	
end
