require File.dirname(__FILE__) + '/../test_helper'

class StageTest < Test::Unit::TestCase

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
  
  def test_should_belong_to_a_competition
    assert_error_on :competition_id, Stage.create()
  end
  
  def test_should_have_a_title
    assert_error_on :title, Stage.create()
    assert_error_on :title, Stage.create(:title => '')
    assert_error_on :title, Stage.create(:title => ' ')
  end
  
  def test_should_have_a_title_that_is_unique_within_its_competition
    stage = Stage.new
    stage.title          = stages(:teststage1).title
    stage.competition_id = stages(:teststage1).competition_id
    stage.save
    assert_error_on :title, stage
  end
  
  def test_should_have_a_title_that_only_contains_alphanumerics_hyphens_and_spaces
    assert_error_on :title, Stage.create(:title => ' %^&* 222 ')
    assert_error_on :title, Stage.create(:title => 'Almost../')
    assert_error_on :title, Stage.create(:title => "<script>alert('Boo')</script>")
    assert_error_on :title, Stage.create(:title => 'This & that')
    assert_error_on :title, Stage.create(:title => 'My stage.')
  end
  
  def test_should_automatically_strip_excess_white_space_from_titles
    stage = stages(:teststage1)
    stage.title = ' spaces at either end '
    stage.save
    stage.reload
    assert_equal 'spaces at either end', stage.title
  end
  
  def test_should_have_a_title_that_is_at_least_4_characters_long
    assert_error_on    :title, Stage.create(:title => '123')
    assert_no_error_on :title, Stage.create(:title => '1234')
  end
  
  def test_should_have_a_title_that_is_at_most_64_characters_long
    assert_error_on    :title, Stage.create(:title => '12345678123456781234567812345678123456781234567812345678123456789')
    assert_no_error_on :title, Stage.create(:title => '1234567812345678123456781234567812345678123456781234567812345678')
  end
  
  def test_should_have_a_url_slug_that_is_auto_generated_from_its_title
    stage = stages(:teststage1)
    
    stage.title = 'A space separated title'
    stage.save
    assert_equal 'a-space-separated-title', stage.slug
    
    stage.title = ' space at either end '
    stage.save
    assert_equal 'space-at-either-end', stage.slug
    
    stage.title = 'Hyphen-in it'
    stage.save
    assert_equal 'hyphen-in-it', stage.slug
  end
  
  def test_should_have_a_url_slug_that_is_unique_within_its_season
    stage = Stage.new
    stage.competition_id = 1
    stage.title = 'Test-Stage One' #similar name to fixtures entry
    stage.save
    assert_error_on :title, stage
  end
  
end
