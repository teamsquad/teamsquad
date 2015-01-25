require 'test_helper'

class AjaxControllerTest < ActionController::TestCase
  
  def test_textile_preview
    assert_routing 'ajax/textile-preview', {:controller => 'ajax', :action => 'textile_preview'}
  end

  def test_textile_preview
    post :textile_preview, test_params
    assert_response :success
    assert_template 'ajax/textile_preview'
    assert_select 'h2', 'Some heading'
    assert_select 'p',  'Some text in a paragraph'
    assert_select 'li', 'Bullet 1'
    assert_select 'li', 'Bullet 2'
  end
  
private

  def test_params
    { :form => { :content => unparsed_textile_source } }
  end

  def unparsed_textile_source
    "h2. Some heading\n\nSome text in a paragraph\n\n* Bullet 1\n* Bullet 2"
  end
end
