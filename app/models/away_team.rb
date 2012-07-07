# This should be considered read only as it wraps an SQL view

class AwayTeam < Team
  
  self.table_name = :away_teams

  belongs_to :match, :foreign_key => 'awayteam_id'
  
end
