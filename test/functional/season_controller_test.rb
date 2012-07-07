require 'test_helper'

class SeasonControllerTest < ActionController::TestCase
  
  fixtures :sports,
           :organisations,
           :users,
           :seasons

  def setup
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_edit_routing
    assert_routing 'http://test.teamsquad.com/edit_season',
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
    assert_template "season/edit"
  end
  
private

  def fake_authorised_user_session
    { :user_id => 1 }
  end

end
