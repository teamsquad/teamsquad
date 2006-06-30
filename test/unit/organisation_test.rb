require File.dirname(__FILE__) + '/../test_helper'

class OrganisationTest < Test::Unit::TestCase
  fixtures :sports, :organisations, :users, :notices, :comments, :pages, :teams, :seasons, :competitions, :stages, :groups, :games

  # Replace this with your real tests.
  def test_can_be_looked_up_by_nickname
    org = Organisation.find_by_nickname('thefa')    
    assert_equal organisations(:thefa).id, org.id
  end
  
  def test_can_lookup_teams
    org = Organisation.find_by_nickname('thefa')
    team = org.find_team('team-two')
    assert_equal teams(:team2).id, team.id
  end
  
  def test_can_lookup_notices
    org = Organisation.find_by_nickname('thefa')
    notice = org.find_notice('notice-one')
    assert_equal notices(:notice1).id, notice.id
  end
  
  def test_can_lookup_pages
    org = Organisation.find_by_nickname('thefa')
    page = org.find_page('this-is-page-one')
    assert_equal pages(:page1).id, page.id
  end

end
