# This should be considered read only as it wraps an SQL view

class TeamMatch < ActiveRecord::Base
  
  belongs_to :team
  belongs_to :competition
  belongs_to :stage
  belongs_to :group
  belongs_to :home_team, :foreign_key => 'hometeam_id'
  belongs_to :away_team, :foreign_key => 'awayteam_id'

  def has_notes?
    (!self.home_notes.nil? && self.home_notes!='') or \
    (!self.away_notes.nil? && self.away_notes!='')
  end

  def has_summary?
    !self.summary.nil? && self.summary!=''
  end

  def state
    if self.played?
      if self.home_points > self.away_points
        'homewin'
      elsif self.home_points < self.away_points
        'awaywin'
      else
        'draw'
      end
    else
      'toplay'
    end
  end

  def has_hierarchy?
    !(stage.lonely? or group.lonely?)
  end
  
  def hierarchy
    what = []
    what << competition.title
    what << stage.title unless stage.lonely?
    what.join(", ")
  end

end
