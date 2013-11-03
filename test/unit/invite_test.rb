require File.dirname(__FILE__) + '/../test_helper'

class InviteTest < ActiveSupport::TestCase
  
  fixtures :invites

  def test_should_prevent_empty_invites
    assert_error_on :code, Invite.create()
  end
  
  def test_should_disallow_empty_codes
    assert_error_on :code, Invite.create(:code => '')
  end
  
  def test_should_disallow_blank_codes
    assert_error_on :code, Invite.create(:code => ' ')
  end
  
  def test_should_disallow_reuse_of_codes
    assert_error_on :code, Invite.create(:code => invites(:unused_invite).code)
  end
  
  def test_should_allow_a_valid_13_digit_codes
    assert_no_error_on :code, Invite.create(code: '6666666666666')
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
