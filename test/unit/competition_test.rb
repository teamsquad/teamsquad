require File.dirname(__FILE__) + '/../test_helper'

class CompetitionTest < Test::Unit::TestCase
  
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
           
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
