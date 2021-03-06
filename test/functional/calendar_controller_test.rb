require 'test_helper'

class CalendarControllerTest < ActionController::TestCase
  
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
   @request.host = 'test.teamsquad.com'
  end
 
  #
  # ROUTING TESTS
  #
  
  def test_competition_calendar_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/calendar',
      { :controller => 'calendar', 
        :action => 'index',
        :competition => 'single-stage-competition' }
  end
  
  def test_competition_calendar_year_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/calendar/2006',
      { :controller => 'calendar',
        :action => 'year',
        :competition => 'single-stage-competition',
        :year => '2006' }
  end
  
  def test_competition_calendar_month_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/calendar/2006/01',
      { :controller => 'calendar',
        :action => 'month',
        :competition => 'single-stage-competition',
        :year => '2006',
        :month => '01' }
  end
  
  def test_competition_calendar_day_routing
    assert_routing 'http://test.teamsquad.com/competitions/single-stage-competition/calendar/2006/01/01',
      { :controller => 'calendar',
        :action => 'day',
        :competition => 'single-stage-competition',
        :year => '2006',
        :month => '01',
        :day => '01' }
  end
  
  #
  # SIMPLE VIEW TESTS
  #
  
  def test_view_competition_calendar
    get :index, :competition => single_stage_competition.slug
    assert_response :success
    assert_template "calendar/index"
  end
  
  def test_view_competition_calendar_year
    get :year,
        :competition => single_stage_competition.slug,
        :year => '2006'
    assert_response :success
    assert_template "calendar/index"
  end
  
  def test_view_competition_calendar_month
    get :month,
        :competition => single_stage_competition.slug,
        :year => '2006',
        :month => '01'
    assert_response :success
    assert_template "calendar/month"
  end
  
  def test_view_competition_calendar_day
    get :day,
        :competition => single_stage_competition.slug,
        :year => '2006',
        :month => '01',
        :day => '01'
    assert_response :success
    assert_template "calendar/day"
  end
  
  #
  # INTERACTIVE TESTS (POST FORMS)
  #
  
  # TODO (include cache sweeping tests)

private
  
  def single_stage_competition
    competitions(:single_stage_competition)
  end

end
