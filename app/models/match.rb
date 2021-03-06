# This should be considered read only as it wraps an SQL view

class Match < ActiveRecord::Base
  
  belongs_to :competition
  belongs_to :stage
  belongs_to :group
  belongs_to :home_team, :foreign_key => 'hometeam_id'
  belongs_to :away_team, :foreign_key => 'awayteam_id'

  def has_notes?
    (!self.home_notes.nil? && self.home_notes!='') or (!self.away_notes.nil? && self.away_notes!='')
  end

  def has_summary?
    !self.summary.nil? && self.summary!=''
  end
  
  def summary_for_news
    if has_summary?
      summary
    else
      case state
        when 'homewin'
          "#{home_team.title} win this #{stage.title} clash."
        when 'awaywin'
          "#{home_team.title} lose out to #{away_team.title} in this #{stage.title} clash."
        when 'draw'
          "This #{stage.title} clash ended in a draw."
        else
          "The match is set for #{pretty_date}."
      end
    end
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
  
  def headline
    if self.played?
      if self.home_points > self.away_points
        "#{home_team.title} beat #{away_team.title}"
      elsif self.home_points < self.away_points
        "#{home_team.title} lose to #{away_team.title}"
      else
        "#{home_team.title} draw with #{away_team.title}"
      end
    else
      "#{home_team.title} to play #{away_team.title}"
    end
  end

end
