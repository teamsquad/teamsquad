class Comment < ActiveRecord::Base
	
	attr :remove
	
	belongs_to :notice, :counter_cache => 'comments_count'
	
	validates_presence_of :name, :content, :message => "You must enter something."
	
end