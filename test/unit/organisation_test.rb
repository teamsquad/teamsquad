require File.dirname(__FILE__) + '/../test_helper'

class OrganisationTest < ActiveSupport::TestCase
  
  fixtures :sports,
           :organisations,
           :users,
           :notices,
           :comments,
           :pages,
           :teams,
           :seasons,
           :competitions,
           :stages,
           :groups,
           :games

  def test_should_belong_to_a_sport
    assert_error_on    :sport_id, Organisation.create()
  end
  
  def test_should_have_a_title
    assert_error_on    :title, Organisation.create()
    assert_error_on    :title, Organisation.create(:title => '')
    assert_error_on    :title, Organisation.create(:title => ' ')
  end
  
  def test_should_have_a_unique_title
    assert_error_on    :title, Organisation.create(:title => organisations(:fifa).title)
  end
  
  def test_should_have_a_title_that_is_at_least_3_characters_long
    assert_error_on    :title, Organisation.create(:title => 'ab')
    assert_no_error_on :title, Organisation.create(:title => 'abc')
  end
  
  def test_should_have_a_title_that_is_at_most_128_characters_long
    assert_error_on    :title, Organisation.create(:title => '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789')
  end
  
  def test_should_have_a_title_that_contains_only_alphanumerics
    assert_error_on    :title, Organisation.create(:title => '$%^&*()')
    assert_error_on    :title, Organisation.create(:title => 'Some-organisation')
    assert_error_on    :title, Organisation.create(:title => 'Org!')
  end
  
  def test_should_have_a_nickname
    assert_error_on    :nickname, Organisation.create()
    assert_error_on    :nickname, Organisation.create(:nickname => '')
    assert_error_on    :nickname, Organisation.create(:nickname => ' ')
    assert_no_error_on :nickname, Organisation.create(:nickname => 'somenickname')
  end
  
  def test_should_have_a_unique_nickname
    assert_error_on    :nickname, Organisation.create(:title => organisations(:fifa).nickname)
  end
  
  def test_should_have_a_nickname_that_is_at_least_3_characters_long
    assert_error_on    :nickname, Organisation.create(:nickname => 'ab')
    assert_no_error_on :nickname, Organisation.create(:nickname => 'abc')
  end
  
  def test_should_have_a_nickname_that_is_at_most_32_characters_long
    assert_error_on    :nickname, Organisation.create(:nickname => '123456789012345678901234567890123')
  end
  
  def test_should_have_a_nickname_that_contains_only_alphanumerics
    assert_error_on    :nickname, Organisation.create(:nickname => '$%^&*()')
    assert_error_on    :nickname, Organisation.create(:nickname => 'some-nick')
    assert_error_on    :nickname, Organisation.create(:nickname => 'some nick')
    assert_error_on    :nickname, Organisation.create(:nickname => 'some_nick')
    assert_error_on    :nickname, Organisation.create(:nickname => 'nick!')
  end
  
  def test_should_have_a_summary
    assert_error_on    :summary, Organisation.create()
    assert_error_on    :summary, Organisation.create(:summary => '')
    assert_error_on    :summary, Organisation.create(:summary => ' ')
  end
  
  def test_should_have_a_summary_that_is_no_longer_than_512_characters
    assert_error_on    :summary, Organisation.create(:summary => string_with_513_characters)
  end
  
  #def test_should_require_sane_organisation_details_when_being_registered
  #  implement_me
  #end
  #
  #def test_should_require_sane_user_details_when_being_registered
  #  implement_me
  #end
  #
  #def test_should_require_a_valid_invite_when_being_registered
  #  implement_me
  #end

  def test_can_be_looked_up_by_nickname
    org = Organisation.find_by_nickname('test')    
    assert_equal organisations(:test).id, org.id
  end
  
  def test_can_lookup_its_teams
    org = Organisation.find_by_nickname('test')
    team = org.find_team('team-two')
    assert_equal teams(:team2).id, team.id
  end
  
  def test_can_lookup_its_notices
    org = Organisation.find_by_nickname('test')
    notice = org.find_notice('notice-one')
    assert_equal notices(:notice1).id, notice.id
  end
  
  def test_can_lookup_its_pages
    org = Organisation.find_by_nickname('test')
    page = org.find_page('this-is-page-one')
    assert_equal pages(:page1).id, page.id
  end

private

  def string_with_513_characters
    str = ''
    513.times { str << 'x' }
    str
  end

end
