Teamsquad::Application.routes.draw do

  # WWW SITE
  
  constraints(:subdomain => '') do
    root :to => 'www#index',
      :as => 'www_home'

    match ':action/(:id)',
      :controller => 'www',
      :constraints => {:id => /\w+(,\w+)*/}
  end

  # ORGANISATION
  
  match '',
    :controller => 'organisation',
    :action => 'home',
    :as => 'home'
    
  match 'edit',
    :controller => 'organisation',
    :action => 'edit',
    :as => 'edit_organisation'

  match 'login',
    :controller => 'organisation',
    :action => 'login',
    :as => 'login'
    
  match 'logout',
    :controller => 'organisation',
    :action => 'logout',
    :as => 'logout'
    
  match 'search',
    :controller => 'organisation',
    :action => 'search',
    :as => 'search'
    
  match 'live_search',
    :controller => 'organisation',
    :action => 'live_search',
    :as => 'live_search'

  match 'edit',
    :controller => 'organisation',
    :action => 'edit',
    :as => 'edit_organisation'

  # AJAX
  
  match 'ajax/:action',
    :controller => 'ajax',
    :as => 'help'

  # CONTROL PANEL
  
  match 'control-panel(/:action)(/:id)',
    :controller => 'control_panel',
    :as => 'control_panel'

  # HELP
  
  match 'help/(:action)',
    :controller => 'help',
    :as => 'help'
  
  # NOTICES
    
  match 'notices',
    :controller => 'notice',
    :action => 'index',
    :as => 'notices'

  match 'notices/new',
    :controller => 'notice',
    :action => 'new',
    :as => 'new_notice'
    
  match 'notices/:notice/edit',
    :controller => 'notice',
    :action => 'edit',
    :as => 'edit_notice'
  
  match 'notices/:notice/commented',
    :controller => 'notice',
    :action => 'commented',
    :as => 'commented'
    
  match 'notices/:notice/moderate',
    :controller => 'notice',
    :action => 'moderate',
    :as => 'moderate_notice' 
  
  match 'notices/:notice',
    :controller => 'notice',
    :action => 'view',
    :as => 'notice'
    
  # INFORMATION
    
  match 'information',
    :controller => 'information',
    :action => 'index',
    :as => 'information'

  match 'information/new',
    :controller => 'information',
    :action => 'new',
    :as => 'new_information_page'
    
  match 'information/:page/edit',
    :controller => 'information',
    :action => 'edit',
    :as => 'edit_information_page'
    
  match 'information/:page',
    :controller => 'information',
    :action => 'view',
    :as => 'information_page'
  
  # SEASON
  
  match 'edit_season',
    :controller => 'season',
    :action => 'edit',
    :as => 'edit_season'
   
  # COMPETITIONS

  match 'competitions',
    :controller => 'competition',
    :action => 'index',
    :as => 'competitions'

  match 'competitions/new',
    :controller => 'competition',
    :action => 'new',
    :as => 'new_competition'
  
  match 'competitions/:competition/edit',
    :controller => 'competition',
    :action => 'edit',
    :as => 'edit_competition'
    
  match 'competitions/:competition',
    :controller => 'competition',
    :action => 'view',
    :as => 'competition'
    
  match 'competitions/:competition/results',
    :controller => 'competition',
    :action => 'results',
    :as => 'competition_results'
    
  match 'competitions/:competition/fixtures',
    :controller => 'competition',
    :action => 'fixtures',
    :as => 'competition_fixtures'
    
  match 'competitions/:competition/add_fixtures',
    :controller => 'competition',
    :action => 'add_fixtures',
    :as => 'competition_add_fixtures'
    
  # CALENDAR
  
  match 'competitions/:competition/calendar',
    :controller => 'calendar',
    :action => 'index',
    :as => 'calendar'
    
  match 'competitions/:competition/calendar/:year',
    :controller => 'calendar',
    :action => 'year',
    :as => 'calendar_year'
    
  match 'competitions/:competition/calendar/:year/:month',
    :controller => 'calendar',
    :action => 'month',
    :as => 'calendar_month'
    
  match 'competitions/:competition/calendar/:year/:month/:day',
    :controller => 'calendar',
    :action => 'day',
    :as => 'calendar_day'
  
  # STAGES
  
  match 'competitions/:competition/new_stage',
    :controller => 'stage',
    :action => 'new',
    :as => 'new_stage'
    
  match 'competitions/:competition/:stage/edit',
    :controller => 'stage',
    :action => 'edit',
    :as => 'edit_stage'
    
  match 'competitions/:competition/:stage',
    :controller => 'stage',
    :action => 'view',
    :as => 'stage'  
  
  # GROUPS
  
  match 'competitions/:competition/:stage/new_group',
    :controller => 'group',
    :action => 'new',
    :as => 'new_group'
    
  match 'competitions/:competition/:stage/:group/edit',
    :controller => 'group',
    :action => 'edit',
    :as => 'edit_group'

  match 'competitions/:competition/:stage/:group/new_fixtures',
    :controller => 'group',
    :action => 'new_fixtures',
    :as => 'new_fixtures'
  
  match 'competitions/:competition/:stage/:group/edit_fixtures',
    :controller => 'group',
    :action => 'edit_fixtures',
    :as => 'edit_fixtures'
    
  match 'competitions/:competition/:stage/:group/enter_results',
    :controller => 'group',
    :action => 'enter_results',
    :as => 'enter_results'
    
  match 'competitions/:competition/:stage/:group/edit_results',
    :controller => 'group',
    :action => 'edit_results',
    :as => 'edit_results'
    
  # TEAMS
  
  match 'teams',
    :controller => 'team',
    :action => 'index',
    :as => 'teams'
    
  match 'teams/new',
    :controller => 'team',
    :action => 'new',
    :as => 'new_team'
    
  match 'teams/:team/edit',
    :controller => 'team',
    :action => 'edit',
    :as => 'edit_team'
    
  match 'teams/:team',
    :controller => 'team',
    :action => 'view',
    :as => 'team'

  match 'teams/:team/fixtures',
    :controller => 'team',
    :action => 'fixtures',
    :as => 'team_fixtures'
  
  match 'teams/:team/results',
    :controller => 'team',
    :action => 'results',
    :as => 'team_results' 


end
