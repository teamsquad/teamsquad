class ContactResponse < ActiveRecord::Base
  
  validates_presence_of :name, :message
  validates_length_of   :name, :maximum => 64, 
                               :on => :create,
                               :message => "Must be 64 characters or less.",
                               :if => Proc.new { |c| !c.name.nil? }
  validates_length_of   :email, :maximum => 64, 
                               :on => :create,
                               :message => "Must be 64 characters or less.",
                               :if => Proc.new { |c| !c.email.nil? }
  
  def hint(name)
    @@hints[name]
  end
  
private

  @@hints = {
    'name' => "Your real name, a nickname, whatever.",
    'email' => "If you want a reply you'd better leave a valid address.",
    'message' => "What do you want to tell us?",
  }
end
