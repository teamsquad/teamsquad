require File.dirname(__FILE__) + '/../test_helper'

class InviteTest < Test::Unit::TestCase
  
  fixtures :invites

  def test_should_have_a_unique_13_digit_code
    assert_error_on    :code, Invite.create()
    assert_error_on    :code, Invite.create(:code => '')
    assert_error_on    :code, Invite.create(:code => ' ')
    assert_error_on    :code, Invite.create(:code => invites(:unused_invite).code)
    assert_no_error_on :code, Invite.create(:code => '6666666666666')
  end
  
  def test_should_be_usable
    assert_true Invite.use( invites(:unused_invite) )
  end
  
  def test_should_be_usable_only_once
    invite = invites(:unused_invite)
    assert_true  Invite.use(invite)
    assert_false Invite.use(invite)
    invite.reload
    assert_true  invite.used?
  end
  
  def test_should_know_if_it_has_been_used
    assert_false invites(:unused_invite).used?
    assert_true  invites(:used_invite).used?
  end
  
end
