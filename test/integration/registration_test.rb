require 'test_helper'

class RegistrationTest < ActionDispatch::IntegrationTest

  fixtures :sports, :invites

  # def test_register_new_organisation
  #   new_session do |eric|
  #     eric.goes_to_registration_form
  #     eric.stupidly_attempts_to_register_with no_registration_params_at_all
  #     eric.stupidly_attempts_to_register_with half_arsed_registration_params
  #     eric.cleverly_attempts_to_register_with good_registration_params
  #     eric.goes_to_view_the_freshly_registered_organisation
  #   end
  # end

private
   
  #
  # Session set up
  #
  
  def new_session
    open_session do |s|
      s.extend(RegistrationDSL)
      s.host! 'www.teamsquad.com'
      yield s if block_given?
    end
  end
  
  #
  # Handy params for posting etc.
  #

  def no_registration_params_at_all
    { }
  end

  def half_arsed_registration_params
    {
      :invite       => { :code => '121212121212' },
      :organisation => { :title => "Eric's cool organisation" },
      :user         => { :name => "Eric Entwhistle" }
    }
  end
  
  def good_registration_params
    {
      :invite => {
        :code => invites(:unused_invite).code
      },
      :organisation => {
        :title    => "Eric and his cool organisation",
        :sport_id => "1",
        :nickname => "eric",
        :summary  => "This is Eric's cool little organisation."
      },
      :user => {
        :name     => "Eric Entwhistle",
        :email    => "eric@example.com",
        :password => "supersecret",
        :password_confirmation => "supersecret"
      }
    }
  end
  
  #
  # My God, Rails rocks...
  #
  
  module RegistrationDSL
    
    def goes_to_registration_form
      get '/register'
      assert_response :success, "#{response.body}"
      assert_template 'www/register'
    end
    
    def stupidly_attempts_to_register_with(options)
      post '/register', options
      assert_response :success
      assert_template 'www/register'
    end
    
    def cleverly_attempts_to_register_with(options)
      post '/register', options
      assert_response :redirect, "#{response.body}"
      follow_redirect!
      assert_response :success, "#{response.body}"
      assert_template 'www/registered'
    end
    
    def goes_to_view_the_freshly_registered_organisation
      get 'http://eric.teamsquad.com/'
      assert_response :success, "#{response.body}"
      assert_template 'organisation/home'
    end
    
  end

end