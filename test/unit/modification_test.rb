require File.dirname(__FILE__) + '/../test_helper'

class ModificationTest < Test::Unit::TestCase
  fixtures :sports, :organisations, :teams, :seasons, :competitions, :stages, :groups, :modifications

  def setup
    @modification = Modification.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Modification,  @modification
  end
end
