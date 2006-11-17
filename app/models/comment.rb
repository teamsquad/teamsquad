class Comment < ActiveRecord::Base
    
  attr :remove
  attr_protected :notice_id
  
  belongs_to :notice, :counter_cache => 'comments_count'
  
  validates_presence_of :name, :content, :message => "You must enter something."
  validates_presence_of :notice_id, :on => :create, :message => "A comment must be associated with a notice."
end
