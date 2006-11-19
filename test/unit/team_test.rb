require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < Test::Unit::TestCase

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

  def test_should_belong_to_an_organisation
    assert_error_on    :organisation_id, Team.create()
  end
  
  def test_should_have_a_title
    assert_error_on    :title, Team.create()
    assert_error_on    :title, Team.create(:title => '')
    assert_error_on    :title, Team.create(:title => ' ')
    assert_no_error_on :title, Team.create(:title => 'A team name')
  end
  
  def test_should_have_a_unique_title_within_its_organisation
    assert_error_on    :title, Team.create(:title => ' ')
  end
  
  def test_should_have_a_title_that_is_at_least_4_characters_long
    assert_error_on    :title, Team.create(:title => '123')
    assert_no_error_on :title, Team.create(:title => '1234')
  end
  
  def test_should_have_a_title_that_is_at_most_64_characters_long
    assert_error_on    :title, Team.create(:title => '12345678901234567890123456789012345678901234567890123456789012345')
  end
  
  def test_should_only_allow_alphanumerics_spaces_periods_and_hyphens_in_its_title
    assert_error_on    :title, Team.create(:title => '$%^&*')
    assert_error_on    :title, Team.create(:title => 'Some title!')
    assert_error_on    :title, Team.create(:title => 'This & that')
    assert_error_on    :title, Team.create(:title => 'Foo/Bar')
    assert_error_on    :title, Team.create(:title => '../../something-secret')
  end
  
end
