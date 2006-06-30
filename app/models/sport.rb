class Sport < ActiveRecord::Base
  
  has_many :organisations
	
	validates_presence_of   :title
	validates_uniqueness_of :title

end
