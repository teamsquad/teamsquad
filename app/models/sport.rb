# Sports determine how various other parts of the system
# behave. An organisaton supports one (and only one) sport.
# The sport selected will alter how games are displayed
# and various other things for each organisation.

class Sport < ActiveRecord::Base
	
	has_many :organisations
	
	validates_presence_of :title
	validates_uniqueness_of :title
	
end
