require File.dirname(__FILE__) + '/../../test_helper'
require 'private/organisation_controller'

# Re-raise errors caught by the controller.
class Private::OrganisationController; def rescue_action(e) raise e end; end

class Private::OrganisationControllerTest < Test::Unit::TestCase
  
  fixtures :sports, :organisations, :users, :seasons
  
  def setup
    @controller = Private::OrganisationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.host = 'thefa.local.domain'
  end

  # This tests are pretty damn weak!

  def test_display_new_notice_form
    get :new_notice
    assert_response :success
  end
  
  def test_post_new_notice_form
    post :new_notice,
      :notice => {
        :heading => 'Some heading',
        :content => 'Some content'
      }
    assert_response :redirect
  end
  
  # def test_only_authorised_users_can_post_notices_to_an_organistion
end
