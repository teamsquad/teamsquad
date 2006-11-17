class Sport < ActiveRecord::Base
  
  has_many :organisations
	
	validates_presence_of   :title
	validates_uniqueness_of :title
	validates_length_of     :title, :maximum => 64, :if => Proc.new {|s| !s.title.nil?}

end
