require 'test_helper'

class OrganisationControllerTest < ActionController::TestCase
  
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
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_home_routing
    assert_routing 'http://test.teamsquad.com/',
      { :controller => 'organisation', :action => 'home' }
  end
  
  def test_login_routing
    assert_routing 'http://test.teamsquad.com/login',
      { :controller => 'organisation', :action => 'login' }
  end
  
  def test_logout_routing
    assert_routing 'http://test.teamsquad.com/logout',
      { :controller => 'organisation', :action => 'logout' }
  end
  
  def test_edit_routing
    assert_routing 'http://test.teamsquad.com/edit',
      { :controller => 'organisation', :action => 'edit' }
  end
  
  def test_live_search_routing
    assert_routing 'http://test.teamsquad.com/live_search',
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
  end
  
  def test_view_login_page
    get :login
    assert_response :success
    assert_template "organisation/login"
  end
  
  def test_view_edit_page
    get :edit, {}, fake_authorised_user_session
    assert_response :success
    assert_template "organisation/edit"
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
