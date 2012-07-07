# encoding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require 'control_panel_controller'

# Re-raise errors caught by the controller.
class ControlPanelController; def rescue_action(e) raise e end; end

class ControlPanelControllerTest < ActionController::TestCase
  
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
    @controller = ControlPanelController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.host = 'test.teamsquad.com'
  end

  #
  # ROUTING TESTS
  #
  
  def test_default_page_route
    assert_routing 'control_panel', {:controller => 'control_panel', :action => 'index'}
  end
  
  def test_list_admins_route
    assert_routing 'control_panel/admins', {:controller => 'control_panel', :action => 'admins'}
  end
  
  def test_new_admin_route
    assert_routing 'control_panel/new_admin', {:controller => 'control_panel', :action => 'new_admin'}
  end
  
  def test_edit_admin_route
    assert_routing 'control_panel/edit_admin', {:controller => 'control_panel', :action => 'edit_admin'}
  end
  
  #
  # ACCCESS CONTROL TESTS
  #
  
  def test_that_default_control_panel_action_is_protected_from_the_public
    get :index
    assert_redirected_to login_url
  end
  
  def test_that_admins_action_is_protected_from_the_public
    get :admins
    assert_redirected_to login_url
  end
  
  def test_that_new_admin_action_is_protected_from_the_public
    get :new_admin
    assert_redirected_to login_url
  end
  
  def test_that_edit_admin_action_is_protected_from_the_public
    get :edit_admin
    assert_redirected_to login_url
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_view_control_panel
    get :index, nil, fake_authorised_user_session
    assert_response :success
    assert_template "control_panel/index"
  end
  
  def test_view_admin_list
    get :admins, nil, fake_authorised_user_session
    assert_response :success
    assert_template "control_panel/admins"
  end
  
  def test_view_new_admin_form
    get :new_admin, { :id => 1 } , fake_authorised_user_session
    assert_response :success
    assert_template "control_panel/new_admin"
  end
  
  def test_view_edit_admin_form
    get :edit_admin, { :id => 1 } , fake_authorised_user_session
    assert_response :success
    assert_template "control_panel/edit_admin"
  end
  
  def test_view_edit_admin_form_with_id_from_another_organisation
    assert_raise(ActiveRecord::RecordNotFound) do
      get :edit_admin, { :id => 2 } , fake_authorised_user_session
      assert_response :missing
    end
  end
  
  def test_view_edit_admin_form_with_really_dodgy_id
    assert_raise(ActiveRecord::RecordNotFound) do
      get :edit_admin, { :id => '£$%^&*(' } , fake_authorised_user_session
      assert_response :missing
    end
  end
  
  #
  # INTERACTIVE TESTS (POST FORMS)
  #
  
  # TODO (include cache sweeping tests)
  
private
  
  def fake_authorised_user_session
    { :user_id => 1 }
  end
  
end
