require File.dirname(__FILE__) + '/../test_helper'
require 'information_controller'

# Re-raise errors caught by the controller.
class InformationController; def rescue_action(e) raise e end; end

class InformationControllerTest < Test::Unit::TestCase
  def setup
    @controller = InformationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
