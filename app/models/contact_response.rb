class ContactResponse < ActiveRecord::Base
  
  validates_presence_of :name, :message
  
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
