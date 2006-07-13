require File.dirname(__FILE__) + '/../test_helper'

class SeasonTest < Test::Unit::TestCase
  
  fixtures :sports,
           :organisations,
           :users,
           :notices,
           :comments,
           :teams,
           :seasons,
           :competitions,
           :stages,
           :groups,
           :games

  def test_can_lookup_competitions_by_slug
    season      = seasons(:season1)
    competition = season.find_competition('single-stage-competition')
    assert_equal competitions(:single_stage_competition), competition
  end
  
  # TODO: this test is crap - only looks at number, not that they are right
  def test_can_lookup_other_competitions
    season             = seasons(:season1)
    number_of_other_competitions = season.competitions.count - 1
    competition        = season.find_competition('single-stage-competition')
    other_competitions = season.competitions_other_than(competition)
    assert_equal number_of_other_competitions, other_competitions.size
  end

end
