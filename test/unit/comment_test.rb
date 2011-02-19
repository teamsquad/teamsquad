require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  
  fixtures :sports,
           :organisations,
           :users,
           :notices,
           :comments
  
  def test_should_have_a_name_for_its_author
    assert_error_on :name, Comment.create()
    assert_error_on :name, Comment.create(:name => '')
    assert_error_on :name, Comment.create(:name => ' ')
    assert_no_error_on :name, Comment.create(:name => 'A Name')
  end
  
  def test_should_have_some_content
    assert_error_on :content, Comment.create()
    assert_error_on :content, Comment.create(:content => '')
    assert_error_on :content, Comment.create(:content => ' ')
    assert_no_error_on :content, Comment.create(:content => 'Some content.')
  end
  
  def test_should_be_attached_to_a_notice
    assert_error_on :notice_id, Comment.create()
  end
  
end
