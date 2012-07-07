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
  
  root :to => 'organisation#home',
    :as => 'home'
  
  match 'login' => 'organisation#login',
    :as => 'login'
  
  match 'logout' => 'organisation#login',
    :as => 'logout'
  
  match 'search' => 'organisation#search',
    :as => 'search'    




  match 'control-panel(/:action)(/:id)',
    :controller => 'control_panel',
    :as => 'control_panel'




    match 'help(/:action)',
      :controller => 'help',
      :as => 'help'





  match 'information' => 'information#index'
  
  match 'information/new' => 'information#new',
    :as => 'new_information_page'
  
  
  
  
  
  match 'notices' => 'notices#index'
  
  match 'notices/new' => 'notices#new',
    :as => 'new_notice'
  
  
  
  
  
  match 'edit-season' => 'season#edit',
    :as => 'edit_season'
  
  
  
  
  match 'competitions/new' => 'competitions#new',
    :as => 'new_competition'
  
  
  match 'teams' => 'teams#index'
  
  

end
