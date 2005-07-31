require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < Test::Unit::TestCase
  fixtures :sports, :organisations, :teams, :seasons, :competitions, :stages, :groups

  def setup
    @team = Team.find(1)
  end

  # Replace this with your real tests.
  def test_is_of_the_kind_team
    assert_kind_of Team,  @team
  end

	def test_does_not_allow_non_alphanumeric_characters_in_the_title
		team = Team.new
		team.title = 'Silly title with odd character"'
		assert !team.save
	end
end
