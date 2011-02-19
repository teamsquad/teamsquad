require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase

  fixtures :sports,
           :organisations,
           :users,
           :pages

  def test_should_belong_to_an_organisation
    assert_error_on    :organisation_id, Page.create()
  end
  
  def test_should_have_a_title
    assert_error_on    :title, Page.create()
    assert_error_on    :title, Page.create(:title => '')
    assert_error_on    :title, Page.create(:title => ' ')
    assert_no_error_on :title, Page.create(:title => 'A page title')
  end
  
  def test_should_have_a_unique_title_within_its_organisation
    page = Page.new
    page.title           = pages(:page1).title
    page.organisation_id = pages(:page1).organisation_id
    page.save
    assert_error_on :title, page
  end
  
  def test_should_have_a_title_that_is_at_least_4_characters_long
    assert_error_on    :title, Team.create(:title => '123')
    assert_no_error_on :title, Team.create(:title => '1234')
  end
  
  def test_should_have_a_title_that_is_at_most_128_characters_long
    assert_error_on    :title, Team.create(:title => '12345678901234567890123456789012345678901234567890123456789012345')
  end
  
  def test_should_have_a_url_slug_that_is_auto_generated_from_its_title
    page = pages(:page1)
    
    page.title = 'A space separated title'
    page.save
    assert_equal 'a-space-separated-title', page.slug
    
    page.title = ' space at either end '
    page.save
    assert_equal 'space-at-either-end', page.slug
    
    page.title = 'Hyphen-in it'
    page.save
    assert_equal 'hyphen-in-it', page.slug
  end
  
  def test_should_have_a_unique_url_slug_within_its_organisation
    page = Page.new
    page.organisation_id = 1
    page.title = 'This-is page one' #similar name to fixtures entry
    page.save
    assert_error_on :title, page
  end
  
  def test_should_have_some_content
    assert_error_on    :content, Page.create()
    assert_error_on    :content, Page.create(:content => '')
    assert_error_on    :content, Page.create(:content => ' ')
    assert_no_error_on :content, Page.create(:content => 'Some content to read.')
  end
  
end
