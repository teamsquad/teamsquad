require File.dirname(__FILE__) + '/../test_helper'
require 'organisation_controller'

# Re-raise errors caught by the controller.
class OrganisationController; def rescue_action(e) raise e end; end

class OrganisationControllerTest < Test::Unit::TestCase
  
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
    @controller = OrganisationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_home_routing
    assert_routing '',
      { :controller => 'organisation', :action => 'home' }
  end
  
  def test_login_routing
    assert_routing 'login',
      { :controller => 'organisation', :action => 'login' }
  end
  
  def test_logout_routing
    assert_routing 'logout',
      { :controller => 'organisation', :action => 'logout' }
  end
  
  def test_edit_routing
    assert_routing 'edit',
      { :controller => 'organisation', :action => 'edit' }
  end
  
  def test_live_search_routing
    assert_routing 'live_search',
      { :controller => 'organisation', :action => 'live_search' }
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_edit_action_is_protected_from_the_public
    get :edit
    assert_redirected_to login_url
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_view_home_page
    get :home
    assert_response :success
    assert_template "organisation/home"
    assert_tidy
  end
  
  def test_view_login_page
    get :login
    assert_response :success
    assert_template "organisation/login"
    assert_tidy
  end
  
  def test_view_edit_page
    get :edit, {}, fake_authorised_user_session
    assert_response :success
    assert_template "organisation/edit"
    assert_tidy
  end
  
  def test_view_live_search
    get :live_search, { :term => 'some search term' }
    assert_response :success
  end
  
private

  def fake_authorised_user_session
    { :user_id => 1 }
  end
  
end
