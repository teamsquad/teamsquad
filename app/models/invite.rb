class Invite < ActiveRecord::Base
  
  attr_accessible :code
  
  validates_presence_of   :code, :message => "Must have a code."
  validates_uniqueness_of :code, :message => "Code must be unique."
  
  def self.use(supplied_invite)
    return false if supplied_invite.nil? || 
                    !supplied_invite.respond_to?(:code) ||
                    supplied_invite.code.nil?
    invite = self.where(used: false, code: supplied_invite.code).first
    if invite.nil?
      supplied_invite.errors.add(:code, 'Not a valid invite code.')
      false
    else
      invite.toggle!(:used)
      true
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
