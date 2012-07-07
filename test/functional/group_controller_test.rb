require 'test_helper'

class GroupControllerTest < ActionController::TestCase
  
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
  
  def test_new_group_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/test-stage-one/new_group',
      { :controller => 'group',
        :action => 'new',
        :competition => 'single-stage-competition',
        :stage => 'test-stage-one' }
  end
  
  def test_edit_group_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/test-stage-one/test-group-one/edit',
      { :controller => 'group',
        :action => 'edit',
        :competition => 'single-stage-competition',
        :stage => 'test-stage-one',
        :group => 'test-group-one' }
  end
  
  def test_new_fixtures_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/test-stage-one/test-group-one/new_fixtures',
      { :controller => 'group',
        :action => 'new_fixtures',
        :competition => 'single-stage-competition',
        :stage => 'test-stage-one',
        :group => 'test-group-one' }
  end
  
  def test_enter_results_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/test-stage-one/test-group-one/enter_results',
      { :controller => 'group',
        :action => 'enter_results',
        :competition => 'single-stage-competition',
        :stage => 'test-stage-one',
        :group => 'test-group-one' }
  end
  
  def test_edit_results_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/test-stage-one/test-group-one/edit_results',
      { :controller => 'group',
        :action => 'edit_results',
        :competition => 'single-stage-competition',
        :stage => 'test-stage-one',
        :group => 'test-group-one' }
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_new_group_action_is_protected_from_the_public
    get :new, { :competition => 'single-stage-competition',
                :stage => 'test-stage-one' }
    assert_redirected_to login_url
  end
  
  def test_that_edit_group_action_is_protected_from_the_public
    get :edit, { :competition => 'single-stage-competition',
                 :stage => 'test-stage-one',
                 :group => 'test-group-one' }
    assert_redirected_to login_url
  end
  
  def test_that_new_fixtures_action_is_protected_from_the_public
    get :new_fixtures, { :competition => 'single-stage-competition',
                 :stage => 'test-stage-one',
                 :group => 'test-group-one' }
    assert_redirected_to login_url
  end
  
  def test_that_enter_results_action_is_protected_from_the_public
    get :enter_results, { :competition => 'single-stage-competition',
                 :stage => 'test-stage-one',
                 :group => 'test-group-one' }
    assert_redirected_to login_url
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_view_new_group_page
    get :new, { :competition => 'single-stage-competition',
                :stage => 'test-stage-one' }, fake_authorised_user_session
    assert_response :success
    assert_template "group/new"
  end
  
  def test_view_edit_group_page
    get :edit, group_params, fake_authorised_user_session
    assert_response :success
    assert_template "group/edit"
  end
  
  def test_view_new_fixtures_page
    get :new_fixtures, group_params, fake_authorised_user_session
    assert_response :success
    assert_template "group/new_fixtures"
  end
  
  def test_view_enter_results_page
    get :enter_results, group_params, fake_authorised_user_session
    assert_response :success
    assert_template "group/enter_results"
  end
  
  #
  # INTERACTIVE TESTS (POST FORMS)
  #
  
  # TODO (include cache sweeping tests)
  
private

  def fake_authorised_user_session
    { :user_id => 1 }
  end
  
  def group_params
    { :competition => 'single-stage-competition',
      :stage => 'test-stage-one',
      :group => 'test-group-one' }
  end
  
end
