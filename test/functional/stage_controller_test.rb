require 'test_helper'

class StageControllerTest < ActionController::TestCase
  
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
  
  def test_new_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/new_stage',
      { :controller  => 'stage',
        :competition => 'single-stage-competition',
        :action      => 'new' }
  end
  
  def test_view_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/test-stage-one',
      { :controller  => 'stage',
        :competition => 'single-stage-competition',
        :stage       => 'test-stage-one',
        :action      => 'view' }
  end
  
  def test_edit_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/test-stage-one/edit',
      { :controller  => 'stage',
        :competition => 'single-stage-competition',
        :stage       => 'test-stage-one',
        :action      => 'edit' }
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_edit_action_is_protected_from_the_public
    get :edit,
      { :competition => 'single-stage-competition',
        :stage       => 'test-stage-one' }
    assert_redirected_to login_url
  end
end
