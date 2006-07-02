require File.dirname(__FILE__) + '/../test_helper'
require 'abstract_account_controller'

# Re-raise errors caught by the controller.
class AbstractAccountController; def rescue_action(e) raise e end; end

class AbstractAccountControllerTest < Test::Unit::TestCase
  def setup
    @controller = AbstractAccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
