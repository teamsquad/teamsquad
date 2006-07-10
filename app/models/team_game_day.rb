# This should be considered read only as it wraps an SQL view

class TeamGameDay < ActiveRecord::Base

  belongs_to :team
  belongs_to :competition
  
end
