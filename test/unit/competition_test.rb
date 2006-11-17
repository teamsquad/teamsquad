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
           
  def test_should_belong_to_a_season
    assert_error_on :season_id, Competition.create()
  end
  
  def test_should_have_a_title
    assert_error_on :title, Competition.create()
    assert_error_on :title, Competition.create(:title => '')
    assert_error_on :title, Competition.create(:title => ' ')
  end
  
  def test_should_have_a_title_that_is_at_least_4_characters_long
    assert_error_on    :title, Competition.create(:title => '123')
    assert_no_error_on :title, Competition.create(:title => '1234')
  end
  
  def test_should_have_a_title_that_is_at_most_64_characters_long
    assert_error_on    :title, Competition.create(:title => '12345678123456781234567812345678123456781234567812345678123456789')
    assert_no_error_on :title, Competition.create(:title => '1234567812345678123456781234567812345678123456781234567812345678')
  end
  
  def test_should_automatically_strip_excess_white_space_from_titles
    comp = competitions(:single_stage_competition)
    comp.title = ' spaces at either end '
    comp.save
    comp.reload
    assert_equal 'spaces at either end', comp.title
  end
  
  def test_should_have_a_title_that_is_unique_within_its_season
    comp = Competition.new
    comp.title     = competitions(:single_stage_competition).title
    comp.season_id = competitions(:single_stage_competition).season_id
    comp.save
    assert_error_on :title, comp
  end
  
  def test_should_have_a_title_containing_only_alphanumerics_hyphens_and_spaces
    assert_error_on :title, Competition.create(:title => ' %^&* 222 ')
    assert_error_on :title, Competition.create(:title => 'Almost../')
    assert_error_on :title, Competition.create(:title => "<script>alert('Boo')</script>")
    assert_error_on :title, Competition.create(:title => 'This & that')
    assert_error_on :title, Competition.create(:title => 'My competition.')
  end
  
  def test_should_have_a_url_slug_that_is_auto_generated_from_its_title
    comp = competitions(:single_stage_competition)
    
    comp.title = 'A space separated title'
    comp.save
    assert_equal 'a-space-separated-title', comp.slug
    
    comp.title = ' space at either end '
    comp.save
    assert_equal 'space-at-either-end', comp.slug
    
    comp.title = 'Hyphen-in it'
    comp.save
    assert_equal 'hyphen-in-it', comp.slug
  end
  
  def test_should_have_a_url_slug_that_is_unique_within_its_season
    comp = Competition.new
    comp.season_id = 1
    comp.title = 'Single-stage competition' #similar name to fixtures entry
    comp.save
    assert_error_on :title, comp
  end
  
  def test_should_optionally_allow_a_label_that_is_at_most_32_characters_long
    assert_error_on    :label, Competition.create(:label => '123456781234567812345678123456789')
    assert_no_error_on :label, Competition.create(:label => '')
    assert_no_error_on :label, Competition.create(:label => '12345678123456781234567812345678')
  end
  
  def test_should_allow_an_empty_league_structure_to_be_created_with_it
    comp = Competition.new(
      :title     => 'Testy',
      :summary   => 'Testing creation of an empty league.',
      :format    => '0'
    )
    comp.season_id = seasons(:empty_season).id
    assert comp.save, comp.errors.inspect.to_s
    comp.reload
    assert_equal 0, comp.stages.count
  end
  
  def test_should_allow_a_simple_league_structure_to_be_created_with_it
    comp = Competition.new(
      :title     => 'Testy',
      :summary   => 'Testing creation of a simple league.',
      :format    => '1'
    )
    comp.season_id = seasons(:empty_season).id
    assert comp.save, comp.errors.inspect.to_s
    comp.reload
    assert_equal 1, comp.stages.count
    assert_equal 1, comp.stages.first.groups.count
  end
  
  def test_should_know_how_many_stages_it_has
    assert_equal 0, competitions(:empty_competition).stages_count
    assert_equal 1, competitions(:single_stage_competition).stages_count
    assert_equal 2, competitions(:two_stage_competition).stages_count
  end
  
end
