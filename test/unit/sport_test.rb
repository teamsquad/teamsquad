require File.dirname(__FILE__) + '/../test_helper'

class SportTest < Test::Unit::TestCase

  fixtures :sports
  
  def test_should_have_a_title
    assert_error_on    :title, Sport.create()
    assert_error_on    :title, Sport.create(:title => '')
    assert_error_on    :title, Sport.create(:title => ' ')
    assert_no_error_on :title, Sport.create(:title => 'Some sport')
  end
  
  def test_should_have_a_unique_title
    assert_error_on    :title, Sport.create(:title => sports(:football).title)
  end
  
  def test_should_have_a_title_that_is_at_most_64_characters_long
    assert_error_on    :title, Sport.create(:title => '12345678901234567890123456789012345678901234567890123456789012345')
  end

end
