require File.dirname(__FILE__) + '/../test_helper'

class GameTest < Test::Unit::TestCase
  
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
           
  def test_should_belong_to_a_group
    assert_error_on    :group_id, Game.create()
  end
  
  def test_should_not_allow_home_notes_to_be_longer_than_64_characters
    assert_error_on    :home_notes, Game.create(:home_notes => '12345678901234567890123456789012345678901234567890123456789012345')
  end
  
  def test_should_not_allow_away_notes_to_be_longer_than_64_characters
    assert_error_on    :away_notes, Game.create(:away_notes => '12345678901234567890123456789012345678901234567890123456789012345')
  end
  
  def test_should_allow_home_team_to_be_left_unassigned
    game = games(:game1)
    game.hometeam_id = nil
    assert_true game.save
    assert_no_error_on :hometeam_id, game
    game.hometeam_id = ''
    assert_true game.save
    assert_no_error_on :hometeam_id, game
    game.hometeam_id = '0'
    assert_true game.save
    assert_no_error_on :hometeam_id, game
  end
  
  def test_should_allow_away_team_to_be_left_unassigned
    game = games(:game1)
    game.awayteam_id = nil
    assert_true game.save
    assert_no_error_on :awayteam_id, game
    game.awayteam_id = ''
    assert_true game.save
    assert_no_error_on :awayteam_id, game
    game.awayteam_id = '0'
    assert_true game.save
    assert_no_error_on :awayteam_id, game
  end
  
  def test_should_ensure_home_team_is_in_its_organisation_if_assigned
    game = games(:game1)
    game.hometeam_id = 10000
    assert_false game.save
    assert_error_on    :hometeam_id, game
  end
  
  def test_should_ensure_away_team_is_in_its_organisation_if_assigned
    game = games(:game1)
    game.awayteam_id = 10000
    assert_false game.save
    assert_error_on    :awayteam_id, game
  end
  
  def test_should_not_be_markable_as_played_unless_both_teams_set
    game = games(:game_with_no_away_team)
    game.played = true
    assert_true     game.unplayable?
    assert_false    game.save
    assert_error_on :played, game
  end
  
  def test_should_know_if_it_has_been_played_or_not
    assert_equal false, games(:unplayed_game).played?
    assert_equal true, games(:played_game).played?
  end
end
