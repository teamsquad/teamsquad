require File.dirname(__FILE__) + '/../test_helper'

class ModificationTest < ActiveSupport::TestCase
  
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
           :games,
           :modifications

  def test_should_belong_to_a_group
    assert_error_on :group_id, Modification.create()
  end
  
  def test_should_belong_to_a_team
    assert_error_on :team_id, Modification.create()
  end
  
  def test_should_allow_positive_points_value
    assert_no_error_on :value, Modification.create(:value => 1)
    assert_no_error_on :value, Modification.create(:value => 10)
  end
  
  def test_should_allow_negative_points_value
    assert_no_error_on :value, Modification.create(:value => -1)
    assert_no_error_on :value, Modification.create(:value => -10)
  end
  
  def test_should_not_allow_zero_points_value
    assert_error_on :value, Modification.create(:value => 0)
  end
  
  def test_should_have_some_notes
    assert_error_on :notes, Modification.create()
    assert_error_on :notes, Modification.create(:notes => '')
    assert_error_on :notes, Modification.create(:notes => ' ')
  end
  
  #def test_should_affect_the_teams_total_points_tally_within_the_group
  #  implement_me
  #end
  
  #def test_should_not_affect_the_teams_total_points_tally_within_other_groups
  #  implement_me
  #end
  
end
