# This should be considered read only as it wraps an SQL view

class Match < ActiveRecord::Base
  
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
  
  def summary_for_news
    if has_summary?
      "#{pretty_date} - #{summary}"
    else
      case state
        when 'homewin'
          "#{pretty_date} - #{home_team.title} win this #{group.title} clash."
        when 'awaywin'
          "#{pretty_date} - #{home_team.title} lose out to #{away_team.title} in this #{group.title} clash."
        when 'draw'
          "#{pretty_date} - This #{group.title} clash ended in a draw."
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
    stage_group = []
    stage_group << stage.title
    stage_group << group.title unless group.lonely?
    stage_group.join(", ")
  end
  
  def headline
    if self.played?
      if self.home_points > self.away_points
        "<strong>#{home_team.title}</strong> beat <strong>#{away_team.title}</strong>"
      elsif self.home_points < self.away_points
        "<strong>#{home_team.title}</strong> lose to <strong>#{away_team.title}</strong>"
      else
        "<strong>#{home_team.title}</strong> draw with <strong>#{away_team.title}</strong>"
      end
    else
      "<strong>#{home_team.title}</strong> to play <strong>#{away_team.title}</strong>"
    end
  end

end
