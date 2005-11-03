class Game < ActiveRecord::Base
	
	belongs_to :group, :counter_cache => 'games_count'

end