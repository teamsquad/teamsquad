# This should be considered read only as it wraps an SQL view

class GameMonth < ActiveRecord::Base
  
  belongs_to :competition
  
end
