# This should be considered read only as it wraps an SQL view

class HomeTeam < Team
  
  self.table_name = :home_teams

  belongs_to :match, :foreign_key => 'hometeam_id'
  
end
