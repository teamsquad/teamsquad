class Invite < ActiveRecord::Base
  
  def self.use(supplied_invite)
    invite = self.find(:first, :conditions => ['code = ?', supplied_invite.code])
    if invite.nil?
      supplied_invite.errors.add(:code, 'Not a valid invite code.')
      false
    else
      invite.toggle!(:used)
    end
  end
  
  def hint(name)
    @@hints[name]
  end
  
protected

  @@hints = {
    'code' => "This is your 13 digit invite code. You can only register once per code.",
  }

end
