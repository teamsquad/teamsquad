require File.dirname(__FILE__) + '/../test_helper'
require 'team_controller'

# Re-raise errors caught by the controller.
class TeamController; def rescue_action(e) raise e end; end

class TeamControllerTest < ActionController::TestCase
  
  fixtures :sports,
           :organisations,
           :users,
           :notices,
           :comments,
           :pages,
           :teams,
           :seasons,
           :competitions,
           :stages,
           :groups,
           :games
           
  def setup
    # Fix Rails induced problem of Integraton tests futzing with stuff.
    if ActionController::Base.respond_to? 'clear_last_instantiation!'
      ActionController::Base.clear_last_instantiation!
    end
    
    @controller = TeamController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_team_list_routing
    assert_routing 'teams',
      { :controller => 'team', :action => 'index' }
  end
  
  def test_new_team_routing
    assert_routing 'teams/new',
      { :controller => 'team', :action => 'new' }
  end
  
  def test_view_team_routing
    assert_routing 'teams/team-one',
      { :controller => 'team', :action => 'view', :team => 'team-one' }
  end
  
  def test_edit_team_routing
    assert_routing 'teams/team-one/edit',
      { :controller => 'team', :action => 'edit', :team => 'team-one' }
  end
  
  def test_view_team__fixtures_routing
    assert_routing 'teams/team-one/fixtures',
      { :controller => 'team', :action => 'fixtures', :team => 'team-one' }
  end
  
  def test_view_team_results_routing
    assert_routing 'teams/team-one/results',
      { :controller => 'team', :action => 'results', :team => 'team-one' }
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_edit_action_is_protected_from_the_public
    get :edit, { :team => 'team-one' }
    assert_redirected_to login_url
  end
  
  def test_that_new_action_is_protected_from_the_public
    get :new
    assert_redirected_to login_url
  end
  
end
