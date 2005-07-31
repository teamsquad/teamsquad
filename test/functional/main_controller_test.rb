require File.dirname(__FILE__) + '/../test_helper'
require 'main_controller'

# Re-raise errors caught by the controller.
class MainController; def rescue_action(e) raise e end; end

class MainControllerTest < Test::Unit::TestCase
	  
	fixtures :sports, :organisations, :teams, :seasons, :competitions, :stages, :groups

	def setup
    @controller = MainController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

		@request.host = "thefa.teamsquad.local"
  end

  def test_homepage_returns_successfuly	
		get :home    
		assert_response :success
  end

	def test_homepage_should_contain_organisation_title
		get :home
		assert_tag :tag => 'a',
			:content => 'The Football Association',
			:parent =>	{ :tag => 'p', :attributes => {:id => 'org'} }	
	end

end
