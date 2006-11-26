require File.dirname(__FILE__) + '/../test_helper'
require 'stage_controller'

# Re-raise errors caught by the controller.
class StageController; def rescue_action(e) raise e end; end

class StageControllerTest < Test::Unit::TestCase
  
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
    @controller = StageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_new_routing
    assert_routing 'competitions/single-stage-competition/new_stage',
      { :controller  => 'stage',
        :competition => 'single-stage-competition',
        :action      => 'new' }
  end
  
  def test_view_routing
    assert_routing 'competitions/single-stage-competition/test-stage-one',
      { :controller  => 'stage',
        :competition => 'single-stage-competition',
        :stage       => 'test-stage-one',
        :action      => 'view' }
  end
  
  def test_edit_routing
    assert_routing 'competitions/single-stage-competition/test-stage-one/edit',
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
      { :controller  => 'stage',
        :competition => 'single-stage-competition',
        :stage       => 'test-stage-one',
        :action      => 'edit' }
    assert_redirected_to login_url
  end
end
