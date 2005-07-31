require File.dirname(__FILE__) + '/../test_helper'

class SeasonTest < Test::Unit::TestCase
  fixtures :sports, :organisations, :teams, :seasons, :competitions, :stages, :groups

  def setup
    @season = Season.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Season,  @season
  end
end
