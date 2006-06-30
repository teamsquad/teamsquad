require File.dirname(__FILE__) + '/../test_helper'
require 'stage_controller'

# Re-raise errors caught by the controller.
class StageController; def rescue_action(e) raise e end; end

class StageControllerTest < Test::Unit::TestCase
  def setup
    @controller = StageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
