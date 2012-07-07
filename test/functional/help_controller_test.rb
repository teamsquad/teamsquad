require File.dirname(__FILE__) + '/../test_helper'
require 'help_controller'

# Re-raise errors caught by the controller.
class HelpController; def rescue_action(e) raise e end; end

class HelpControllerTest < ActionController::TestCase
  def setup
    @controller = HelpController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_index_routing
    assert_routing 'help',
      {:controller => 'help', :action => 'index'}
  end
  
  def test_formatting_text_routing
    assert_routing 'help/formatting_text',
      {:controller => 'help', :action => 'formatting_text'}
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_view_index
    get :index
    assert_response :success
    assert_template "help/index"
  end
  
  def test_view_formatting_text
    get :formatting_text
    assert_response :success
    assert_template "help/formatting_text"
  end
end
