require File.dirname(__FILE__) + '/../test_helper'

class NoticeTest < Test::Unit::TestCase

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
    assert_error_on    :organisation_id, Notice.create()
  end
  
  def test_should_belong_to_an_author
    assert_error_on    :user_id, Notice.create()
  end
  
  def test_should_have_a_heading
    assert_error_on    :heading, Notice.create()
  end
  
  def test_should_have_a_heading_that_is_unique_within_its_organisation
    notice = Notice.new
    notice.heading         = notices(:notice1).heading
    notice.organisation_id = notices(:notice1).organisation_id
    notice.save
    assert_error_on :heading, notice
  end
  
  def test_should_have_a_heading_that_is_at_least_4_characters_long
    assert_error_on    :heading, Notice.create(:heading => '123')
    assert_no_error_on :heading, Notice.create(:heading => '1234')
  end
  
  def test_should_have_a_heading_that_is_at_most_128_characters_long
    assert_error_on    :heading, Notice.create(:heading => '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789')
  end
  
  def test_should_automatically_strip_excess_white_space_from_heading
    notice = notices(:notice1)
    notice.heading = ' spaces at either end '
    notice.save
    notice.reload
    assert_equal 'spaces at either end', notice.heading
  end
  
  def test_should_have_a_url_slug_that_is_auto_generated_from_its_heading
    notice = notices(:notice1)
    
    notice.heading = 'A space separated heading'
    notice.save
    assert_equal 'a-space-separated-heading', notice.slug
    
    notice.heading = ' space at either end '
    notice.save
    assert_equal 'space-at-either-end', notice.slug
    
    notice.heading = 'Hyphen-in it'
    notice.save
    assert_equal 'hyphen-in-it', notice.slug
  end
  
  def test_should_have_a_url_slug_that_is_unique_within_its_organisation
    notice = Notice.new
    notice.organisation_id = 1
    notice.heading = 'Notice-One' #similar name to fixtures entry
    notice.save
    assert_error_on :heading, notice
  end
  
  def test_should_have_some_content
    assert_error_on    :content, Notice.create()
    assert_error_on    :content, Notice.create(:content => '')
    assert_error_on    :content, Notice.create(:content => ' ')
    assert_no_error_on :content, Notice.create(:content => 'Some content.')
  end
  
end
