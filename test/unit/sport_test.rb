require File.dirname(__FILE__) + '/../test_helper'

class SportTest < Test::Unit::TestCase
  fixtures :sports

  def setup
    @sport = Sport.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Sport,  @sport
  end
end
