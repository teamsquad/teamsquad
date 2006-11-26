require File.dirname(__FILE__) + '/../test_helper'
require 'information_controller'

# Re-raise errors caught by the controller.
class InformationController; def rescue_action(e) raise e end; end

class InformationControllerTest < Test::Unit::TestCase
  
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
    @controller = InformationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_index_routing
    assert_routing 'information',
      { :controller => 'information', :action => 'index' }
  end
  
  def test_view_page_routing
    assert_routing 'information/this-is-page-one',
      { :controller => 'information', :action => 'view', :page => 'this-is-page-one' }
  end
  
  def test_new_page_routing
    assert_routing 'information/new',
      { :controller => 'information', :action => 'new' }
  end
  
  def test_edit_page_routing
    assert_routing 'information/this-is-page-one/edit',
      { :controller => 'information', :action => 'edit', :page => 'this-is-page-one' }
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_new_page_action_is_protected_from_the_public
    get :new
    assert_redirected_to login_url
  end
  
  def test_that_edit_page_action_is_protected_from_the_public
    get :new, {:page => 'this-is-page-one'}
    assert_redirected_to login_url
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_initial_information_page
    get :index
    assert_response :success
    assert_template "information/index"
    assert_tidy
  end
  
  def test_view_information_page
    get :view, {:page => 'this-is-page-one'}
    assert_response :success
    assert_template "information/view"
    assert_tidy
  end
  
  def test_new_information_page
    get :new, {}, fake_authorised_user_session
    assert_response :success
    assert_template "information/new"
    assert_tidy
  end
  
  def test_edit_information_page
    get :edit, {:page => 'this-is-page-one'}, fake_authorised_user_session
    assert_response :success
    assert_template "information/edit"
    assert_tidy
  end
  
private

  def fake_authorised_user_session
    { :user_id => 1 }
  end
  
end
