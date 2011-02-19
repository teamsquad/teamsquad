require File.dirname(__FILE__) + '/../test_helper'
require 'www_controller'

# Re-raise errors caught by the controller.
class WwwController; def rescue_action(e) raise e end; end

class WwwControllerTest < ActionController::TestCase
  def setup
    @controller = WwwController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
