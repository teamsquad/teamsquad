Teamsquad::Application.routes.draw do

  # WWW SITE
  
  constraints(:subdomain => '') do
    root :to => 'www#index',
      :as => 'www_home'

    get ':action/(:id)',
      :controller => 'www',
      :constraints => {:id => /\w+(,\w+)*/}
  end
  
  get 'the-rec',
    :controller => 'organisation',
    :action => 'venue',
    :as => 'venue'

  # ORGANISATION
  
  get '',
    :controller => 'organisation',
    :action => 'index',
    :as => 'home'
    
  match 'edit',
    :controller => 'organisation',
    :action => 'edit',
    :as => 'edit_organisation',
    :via => [:get, :post]

  match 'login',
    :controller => 'organisation',
    :action => 'login',
    :as => 'login',
    :via => [:get, :post]
    
  match 'logout',
    :controller => 'organisation',
    :action => 'logout',
    :as => 'logout',
    :via => [:get, :post]
    
  get 'search',
    :controller => 'organisation',
    :action => 'search',
    :as => 'search'
    
  get 'live-search',
    :controller => 'organisation',
    :action => 'live_search',
    :as => 'live_search'

  # AJAX
  
  get 'ajax/:action',
    :controller => 'ajax',
    :as => 'ajax'

  # CONTROL PANEL

  match 'control-panel/new-admin',
    :controller => 'control_panel',
    :action => 'new_admin',
    :as => 'new_admin',
    :via => [:get, :post]
    
  match 'control-panel/edit-admin(/:id)',
    :controller => 'control_panel',
    :action => 'edit_admin',
    :as => 'edit_admin',
    :via => [:get, :post]

  get 'control-panel(/:action)(/:id)',
    :controller => 'control_panel',
    :as => 'control_panel'

  # HELP
  
  get 'help/(:action)',
    :controller => 'help',
    :as => 'help'
  
  # NOTICES
    
  get 'notices',
    :controller => 'notice',
    :action => 'index',
    :as => 'notices'

  match 'notices/new',
    :controller => 'notice',
    :action => 'new',
    :as => 'new_notice',
    :via => [:get, :post]
    
  match 'notices/:notice/edit',
    :controller => 'notice',
    :action => 'edit',
    :as => 'edit_notice',
    :via => [:get, :post]
  
  get 'notices/:notice/commented',
    :controller => 'notice',
    :action => 'commented',
    :as => 'commented'
    
  match 'notices/:notice/moderate',
    :controller => 'notice',
    :action => 'moderate',
    :as => 'moderate_notice' ,
    :via => [:get, :post]
  
  get 'notices/:notice',
    :controller => 'notice',
    :action => 'view',
    :as => 'notice'
    
  # INFORMATION
    
  get 'information',
    :controller => 'information',
    :action => 'index',
    :as => 'information'

  match 'information/new',
    :controller => 'information',
    :action => 'new',
    :as => 'new_information_page',
    :via => [:get, :post]
    
  match 'information/:page/edit',
    :controller => 'information',
    :action => 'edit',
    :as => 'edit_information_page',
    :via => [:get, :post]
    
  get 'information/:page',
    :controller => 'information',
    :action => 'view',
    :as => 'information_page'
  
  # SEASON
  
  match 'edit-season',
    :controller => 'season',
    :action => 'edit',
    :as => 'edit_season',
    :via => [:get, :post]
    
  get 'archive',
    :controller => 'season',
    :action => 'archive',
    :as => 'archive'
    
  get 'archive/:season',
    :controller => 'season',
    :action => 'view',
    :as => 'season'
   
  # COMPETITIONS

  get 'competitions',
    :controller => 'competition',
    :action => 'index',
    :as => 'competitions'

  match 'competitions/new',
    :controller => 'competition',
    :action => 'new',
    :as => 'new_competition',
    :via => [:get, :post]
  
  match 'competitions/:competition/edit',
    :controller => 'competition',
    :action => 'edit',
    :as => 'edit_competition',
    :via => [:get, :post]
    
  get 'competitions/:competition',
    :controller => 'competition',
    :action => 'view',
    :as => 'competition'
    
  get 'competitions/:competition/results',
    :controller => 'competition',
    :action => 'results',
    :as => 'competition_results'
    
  get 'competitions/:competition/fixtures',
    :controller => 'competition',
    :action => 'fixtures',
    :as => 'competition_fixtures'
    
  match 'competitions/:competition/add-fixtures',
    :controller => 'competition',
    :action => 'add_fixtures',
    :as => 'competition_add_fixtures',
    :via => [:get, :post]
    
  # CALENDAR
  
  get 'competitions/:competition/calendar',
    :controller => 'calendar',
    :action => 'index',
    :as => 'calendar'
    
  get 'competitions/:competition/calendar/:year',
    :controller => 'calendar',
    :action => 'year',
    :as => 'calendar_year'
    
  get 'competitions/:competition/calendar/:year/:month',
    :controller => 'calendar',
    :action => 'month',
    :as => 'calendar_month'
    
  get 'competitions/:competition/calendar/:year/:month/:day',
    :controller => 'calendar',
    :action => 'day',
    :as => 'calendar_day'
  
  # STAGES
  
  match 'competitions/:competition/new-stage',
    :controller => 'stage',
    :action => 'new',
    :as => 'new_stage',
    :via => [:get, :post]
    
  match 'competitions/:competition/:stage/edit',
    :controller => 'stage',
    :action => 'edit',
    :as => 'edit_stage',
    :via => [:get, :post]
    
  get 'competitions/:competition/:stage',
    :controller => 'stage',
    :action => 'view',
    :as => 'stage'  
  
  # GROUPS
  
  match 'competitions/:competition/:stage/new-group',
    :controller => 'group',
    :action => 'new',
    :as => 'new_group',
    :via => [:get, :post]
    
  match 'competitions/:competition/:stage/:group/edit',
    :controller => 'group',
    :action => 'edit',
    :as => 'edit_group',
    :via => [:get, :post]

  match 'competitions/:competition/:stage/:group/new-fixtures',
    :controller => 'group',
    :action => 'new_fixtures',
    :as => 'new_fixtures',
    :via => [:get, :post]
  
  match 'competitions/:competition/:stage/:group/edit-fixtures',
    :controller => 'group',
    :action => 'edit_fixtures',
    :as => 'edit_fixtures',
    :via => [:get, :post]
    
  match 'competitions/:competition/:stage/:group/enter-results',
    :controller => 'group',
    :action => 'enter_results',
    :as => 'enter_results',
    :via => [:get, :post]
    
  match 'competitions/:competition/:stage/:group/edit-results',
    :controller => 'group',
    :action => 'edit_results',
    :as => 'edit_results',
    :via => [:get, :post]
    
  # TEAMS
  
  get 'teams',
    :controller => 'team',
    :action => 'index',
    :as => 'teams'
    
  match 'teams/new',
    :controller => 'team',
    :action => 'new',
    :as => 'new_team',
    :via => [:get, :post]
    
  match 'teams/:team/edit',
    :controller => 'team',
    :action => 'edit',
    :as => 'edit_team',
    :via => [:get, :post]
    
  get 'teams/:team',
    :controller => 'team',
    :action => 'view',
    :as => 'team'

  get 'teams/:team/fixtures',
    :controller => 'team',
    :action => 'fixtures',
    :as => 'team_fixtures'
  
  get 'teams/:team/results',
    :controller => 'team',
    :action => 'results',
    :as => 'team_results' 

end
