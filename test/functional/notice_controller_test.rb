require File.dirname(__FILE__) + '/../test_helper'
require 'notice_controller'

# Re-raise errors caught by the controller.
class NoticeController; def rescue_action(e) raise e end; end

class NoticeControllerTest < ActionController::TestCase
  
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
    @controller = NoticeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_index_routing
    assert_routing 'notices',
      { :controller => 'notice', :action => 'index' }
  end
  
  def test_view_notice_routing
    assert_routing 'notices/notice-one',
      { :controller => 'notice', :action => 'view', :notice => 'notice-one' }
  end
  
  def test_new_notice_routing
    assert_routing 'notices/new',
      { :controller => 'notice', :action => 'new' }
  end
  
  def test_edit_notice_routing
    assert_routing 'notices/notice-one/edit',
      { :controller => 'notice', :action => 'edit', :notice => 'notice-one' }
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_new_notice_action_is_protected_from_the_public
    get :new
    assert_redirected_to login_url
  end
  
  def test_that_edit_notice_action_is_protected_from_the_public
    get :new, {:page => 'notice-one'}
    assert_redirected_to login_url
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_initial_notice_page
    get :index
    assert_response :success
    assert_template "notice/index"
    assert_tidy
  end
  
  def test_view_notice_page
    get :view, {:notice => 'notice-one'}
    assert_response :success
    assert_template "notice/view"
    assert_tidy
  end
  
  def test_new_notice_page
    get :new, {}, fake_authorised_user_session
    assert_response :success
    assert_template "notice/new"
    assert_tidy
  end
  
  def test_edit_notice_page
    get :edit, {:notice => 'notice-one'}, fake_authorised_user_session
    assert_response :success
    assert_template "notice/edit"
    assert_tidy
  end
  
private

  def fake_authorised_user_session
    { :user_id => 1 }
  end
end
