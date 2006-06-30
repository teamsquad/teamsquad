class Game < ActiveRecord::Base
  
  attr_protected :group_id
  
  belongs_to :group, :counter_cache => 'games_count'
  belongs_to :home_team, :foreign_key => 'hometeam_id'
  belongs_to :away_team, :foreign_key => 'awayteam_id'

end
