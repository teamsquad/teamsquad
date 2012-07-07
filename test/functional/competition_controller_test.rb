require 'test_helper'

class CompetitionControllerTest < ActionController::TestCase
  
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
  
  def test_new_competition_routing
    assert_routing 'http://test.teamsquad.com/competitions/new', {:controller => 'competition', :action => 'new'}
  end
  
  def test_view_competition_routing  
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition', {:controller => 'competition', :competition => 'single-stage-competition', :action => 'view'}
  end
  
  def test_edit_competition_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/edit', {:controller => 'competition', :competition => 'single-stage-competition', :action => 'edit'}
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_new_competition_action_is_protected_from_the_public
    get :new
    assert_redirected_to login_url
  end
  
  def test_that_edit_competition_action_is_protected_from_the_public
    get :edit, single_stage_competition_param
    assert_redirected_to login_url
  end
  
  def test_that_new_competition_action_is_available_to_authorised_users
    get :new, nil, fake_authorised_user_session
    assert_response :success
    assert_template "competition/new"
  end
  
  def test_that_edit_competition_action_is_available_to_authorised_users
    get :edit, single_stage_competition_param, fake_authorised_user_session
    assert_response :success
    assert_template "competition/edit"
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_view_competition
    get :view, single_stage_competition_param
    assert_response :success
    assert_template "competition/view"
    assert_tag :tag => 'h1', :content => single_stage_competition.title
  end
  
  def test_view_competition_fixtures
    get :fixtures, single_stage_competition_param
    assert_response :success
    assert_template "competition/fixtures"
  end
  
  def test_view_competition_results
    get :results, single_stage_competition_param
    assert_response :success
    assert_template "competition/results"
  end
  
  #
  # INTERACTIVE TESTS (POST FORMS)
  #
  
  # TODO (include cache sweeping tests)
  
private

  def fake_authorised_user_session
    { :user_id => 1 }
  end
  
  def single_stage_competition
    competitions(:single_stage_competition)
  end
  
  def single_stage_competition_param
    { :competition => single_stage_competition.slug }
  end

end
