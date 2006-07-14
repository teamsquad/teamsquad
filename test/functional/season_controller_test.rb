require File.dirname(__FILE__) + '/../test_helper'
require 'season_controller'

# Re-raise errors caught by the controller.
class SeasonController; def rescue_action(e) raise e end; end

class SeasonControllerTest < Test::Unit::TestCase
  def setup
    @controller = SeasonController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
