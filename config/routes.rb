ActionController::Routing::Routes.draw do |map|
  # First created -> highest priority.
  # Mapping each URL individually to get separate named_url methods.
  # Keeps code in views short and avoids routing clashes on complex URLs.
  # Sure is a long routes file though ;)
  
  # WWW SITE
  
  map.www_home '',
    :controller => 'www',
    :conditions => { :subdomain => 'www' }
  
  map.www_generic ':action/:id',
    :controller => 'www',
    :conditions => { :subdomain => 'www' }
  
  # ORGANISATION
  
  map.home  '',
    :controller => 'organisation',
    :action => 'home'
    
  map.edit_organisation 'edit',
    :controller => 'organisation',
    :action => 'edit'

  map.login 'login',
    :controller => 'organisation',
    :action => 'login'
    
  map.logout 'logout',
    :controller => 'organisation',
    :action => 'logout'
    
  map.search 'search',
    :controller => 'organisation',
    :action => 'search'
    
  map.live_search 'live_search',
    :controller => 'organisation',
    :action => 'live_search'

  map.edit_organisation 'edit',
    :controller => 'organisation',
    :action => 'edit'
  
  # HELP
  
  map.help 'help/:action',
    :controller => 'help'
  
  # NOTICES
    
  map.notices 'notices',
    :controller => 'notice',
    :action => 'index'

  map.new_notice 'notices/new',
    :controller => 'notice',
    :action => 'new'
    
  map.edit_notice 'notices/:notice/edit',
    :controller => 'notice',
    :action => 'edit'
  
  map.commented 'notices/:notice/commented',
    :controller => 'notice',
    :action => 'commented'
    
  map.edit_comments 'notices/:notice/edit-comments',
    :controller => 'notice',
    :action => 'edit_comments' 
  
  map.notice 'notices/:notice',
    :controller => 'notice',
    :action => 'view'
    
  # INFORMATION
    
  map.information 'information',
    :controller => 'information',
    :action => 'index'

  map.new_information_page 'information/new',
    :controller => 'information',
    :action => 'new'
    
  map.edit_information_page 'information/edit/:page',
    :controller => 'information',
    :action => 'edit'
    
  map.information_page 'information/:page',
    :controller => 'information',
    :action => 'view'
    
  # COMPETITIONS

  map.competitions 'competitions',
    :controller => 'competition',
    :action => 'index'

  map.new_competition 'competitions/new',
    :controller => 'competition',
    :action => 'new'
  
  map.edit_competition 'competitions/:competition/edit',
    :controller => 'competition',
    :action => 'edit'
    
  map.competition 'competitions/:competition',
    :controller => 'competition',
    :action => 'view'
    
  map.competition_results 'competitions/:competition/results',
    :controller => 'competition',
    :action => 'results'
    
  map.competition_fixtures 'competitions/:competition/fixtures',
    :controller => 'competition',
    :action => 'fixtures'
    
  # CALENDAR
  
  map.calendar 'competitions/:competition/calendar',
    :controller => 'calendar',
    :action => 'index'
    
  map.calendar_year 'competitions/:competition/calendar/:year',
    :controller => 'calendar',
    :action => 'year'
    
  map.calendar_month 'competitions/:competition/calendar/:year/:month',
    :controller => 'calendar',
    :action => 'month'
    
  map.calendar_day 'competitions/:competition/calendar/:year/:month/:day',
    :controller => 'calendar',
    :action => 'day'
  
  # STAGES
  
  map.new_stage 'competitions/:competition/new_stage',
    :controller => 'stage',
    :action => 'new'
    
  map.edit_stage 'competitions/:competition/:stage/edit',
    :controller => 'stage',
    :action => 'edit'
    
  map.stage 'competitions/:competition/:stage',
    :controller => 'stage',
    :action => 'view'  
  
  # GROUPS
  
  map.new_group 'competitions/:competition/:stage/new_group',
    :controller => 'group',
    :action => 'new'
    
  map.edit_group 'competitions/:competition/:stage/:group/edit',
    :controller => 'group',
    :action => 'edit'

  map.new_fixtures 'competitions/:competition/:stage/:group/new_fixtures',
    :controller => 'group',
    :action => 'new_fixtures'
  
  map.edit_fixtures 'competitions/:competition/:stage/:group/edit_fixtures',
    :controller => 'group',
    :action => 'edit_fixtures'
    
  map.enter_results 'competitions/:competition/:stage/:group/enter_results',
    :controller => 'group',
    :action => 'enter_results'
    
  map.edit_results 'competitions/:competition/:stage/:group/edit_results',
    :controller => 'group',
    :action => 'edit_results'
    
  # TEAMS
  
  map.teams 'teams',
    :controller => 'team',
    :action => 'index'
    
  map.new_team 'teams/new',
    :controller => 'team',
    :action => 'new'
    
  map.team 'teams/:team',
    :controller => 'team',
    :action => 'view'
    
end