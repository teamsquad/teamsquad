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

  def test_should_belong_to_an_organisation
    assert_error_on :organisation_id, Season.create()
  end
  
  def test_should_have_a_title
    assert_error_on :title, Season.create()
    assert_error_on :title, Season.create(:title => '')
    assert_error_on :title, Season.create(:title => ' ')
  end
  
  def test_should_have_a_unique_title_within_its_organisation
    season = Season.new
    season.title           = seasons(:season1).title
    season.organisation_id = seasons(:season1).organisation_id
    season.save
    assert_error_on :title, season
  end
  
  def test_should_have_a_title_that_is_at_least_4_characters_long
    assert_error_on    :title, Season.create(:title => '123')
    assert_no_error_on :title, Season.create(:title => '1234')
  end
  
  def test_should_have_a_title_that_is_at_most_64_characters_long
    assert_error_on    :title, Season.create(:title => '12345678123456781234567812345678123456781234567812345678123456789')
    assert_no_error_on :title, Season.create(:title => '1234567812345678123456781234567812345678123456781234567812345678')
  end
  
  def test_should_only_allow_alphanumerics_spaces_and_hyphens_in_its_title
    assert_error_on :title, Season.create(:title => ' %^&* 222 ')
    assert_error_on :title, Season.create(:title => 'Almost../')
    assert_error_on :title, Season.create(:title => "<script>alert('Boo')</script>")
    assert_error_on :title, Season.create(:title => 'This & that')
    assert_error_on :title, Season.create(:title => 'My season.')
  end
  
  def test_should_automatically_strip_excess_white_space_from_titles
    season = seasons(:season1)
    season.title = ' spaces at either end '
    season.save
    season.reload
    assert_equal 'spaces at either end', season.title
  end
  
  def test_should_have_a_url_slug_that_is_auto_generated_from_its_title
    season = seasons(:season1)
    
    season.title = 'A space separated title'
    season.save
    assert_equal 'a-space-separated-title', season.slug
    
    season.title = ' space at either end '
    season.save
    assert_equal 'space-at-either-end', season.slug
    
    season.title = 'Hyphen-in it'
    season.save
    assert_equal 'hyphen-in-it', season.slug
  end
  
  def test_should_have_a_url_slug_that_is_unique_within_its_organisation
    season = Season.new
    season.organisation_id = 1
    season.title = 'Season-1' #similar name to fixtures entry
    assert_false season.save
    assert_error_on :title, season
  end

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
