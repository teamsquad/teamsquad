require File.dirname(__FILE__) + '/../test_helper'

class ContactResponseTest < Test::Unit::TestCase
  
  fixtures :contact_responses
  
  def test_should_have_a_name_for_its_author
    assert_error_on    :name, ContactResponse.create()
    assert_error_on    :name, ContactResponse.create(:name => '')
    assert_error_on    :name, ContactResponse.create(:name => ' ')
    assert_no_error_on :name, ContactResponse.create(:name => 'Some name')
  end
  
  def test_should_not_allow_an_author_name_greater_than_64_characters_long
    assert_error_on    :name, ContactResponse.create(:name => '12345678901234567890123456789012345678901234567890123456789012345')
  end
  
  def test_should_allow_for_an_optional_email_address
    assert_no_error_on :email, ContactResponse.create()
    assert_no_error_on :email, ContactResponse.create(:email => 'dummy@example.com')
  end
  
  def test_should_not_allow_an_email_address_greater_than_64_characters_long
    assert_error_on    :email, ContactResponse.create(:email => '12345678901234567890123456789012345678901234567890123456789012345')
  end

  def test_should_have_a_message
    assert_error_on    :message, ContactResponse.create()
    assert_error_on    :message, ContactResponse.create(:message => '')
    assert_error_on    :message, ContactResponse.create(:message => ' ')
    assert_no_error_on :message, ContactResponse.create(:message => 'Some message.')
  end
  
end
