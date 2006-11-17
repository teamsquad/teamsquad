require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase
  
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
  
  def test_should_have_a_title
    assert_error_on    :title, Group.create()
    assert_error_on    :title, Group.create(:title => '')
    assert_error_on    :title, Group.create(:title => ' ')
    assert_no_error_on :title, Group.create(:title => 'Some title')
  end
  
  def test_should_have_a_title_that_is_unique_within_its_stage
    group = Group.new
    group.title    = groups(:testgroup1).title
    group.stage_id = groups(:testgroup1).stage_id
    group.save
    assert_error_on :title, group
  end
  
  def test_should_have_a_title_that_only_contains_alphanumerics_hyphens_and_spaces
    assert_error_on :title, Group.create(:title => ' %^&* 222 ')
    assert_error_on :title, Group.create(:title => 'Almost../')
    assert_error_on :title, Group.create(:title => "<script>alert('Boo')</script>")
    assert_error_on :title, Group.create(:title => 'This & that')
    assert_error_on :title, Group.create(:title => 'My group.')
  end
  
  def test_should_have_a_title_that_is_at_least_4_characters_long
    assert_error_on    :title, Group.create(:title => '123')
    assert_no_error_on :title, Group.create(:title => '1234')
  end
  
  def test_should_have_a_title_that_is_at_most_64_characters_long
    assert_error_on    :title, Group.create(:title => '12345678123456781234567812345678123456781234567812345678123456789')
    assert_no_error_on :title, Group.create(:title => '1234567812345678123456781234567812345678123456781234567812345678')
  end
  
  def test_should_automatically_strip_excess_white_space_from_titles
    group = groups(:testgroup1)
    group.title = ' spaces at either end '
    group.save
    group.reload
    assert_equal 'spaces at either end', group.title
  end
  
  def test_should_have_a_url_slug_automatically_created_from_its_title
    group = groups(:testgroup1)
    
    group.title = 'A space separated title'
    group.save
    assert_equal 'a-space-separated-title', group.slug
    
    group.title = ' space at either end '
    group.save
    assert_equal 'space-at-either-end', group.slug
    
    group.title = 'Hyphen-in it'
    group.save
    assert_equal 'hyphen-in-it', group.slug
  end
  
  def test_should_have_a_url_slug_that_is_unique_within_its_stage
    group = Group.new
    group.stage_id = 1
    group.title = 'Test-Group one' #similar name to fixtures entry
    group.save
    assert_error_on :title, group
  end
  
end
