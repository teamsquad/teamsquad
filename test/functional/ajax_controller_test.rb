require File.dirname(__FILE__) + '/../test_helper'
require 'ajax_controller'

# Re-raise errors caught by the controller.
class AjaxController; def rescue_action(e) raise e end; end

class AjaxControllerTest < ActionController::TestCase
  def setup
    @controller = AjaxController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_textile_preview
    assert_routing 'ajax/textile_preview', {:controller => 'ajax', :action => 'textile_preview'}
  end

  def test_textile_preview
    post :textile_preview, test_params
    assert_response :success
    assert_template 'ajax/textile_preview'
    assert_tag :tag => 'h2',  :content => 'Some heading'
    assert_tag :tag => 'p',   :content => 'Some text in a paragraph'
    assert_tag :tag => 'li',  :content => 'Bullet 1'
    assert_tag :tag => 'li',  :content => 'Bullet 2'
  end
  
private

  def test_params
    { :form => { :content => unparsed_textile_source } }
  end

  def unparsed_textile_source
    "h2. Some heading\n\nSome text in a paragraph\n\n* Bullet 1\n* Bullet 2"
  end
end
