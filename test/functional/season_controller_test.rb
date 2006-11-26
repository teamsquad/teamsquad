require File.dirname(__FILE__) + '/../test_helper'
require 'season_controller'

# Re-raise errors caught by the controller.
class SeasonController; def rescue_action(e) raise e end; end

class SeasonControllerTest < Test::Unit::TestCase
  
  fixtures :sports,
           :organisations,
           :users,
           :seasons
  
  def setup
    @controller = SeasonController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_edit_routing
    assert_routing 'edit_season',
      { :controller => 'season', :action => 'edit' }
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
  
  def test_view_edit_page
    get :edit, {}, fake_authorised_user_session
    assert_response :success
    assert_template "season/edit", @controller.class.to_s
    assert_tidy
  end
  
private

  def fake_authorised_user_session
    { :user_id => 1 }
  end

end
