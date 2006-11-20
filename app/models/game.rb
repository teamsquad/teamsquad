class Game < ActiveRecord::Base
  
  attr_protected :group_id
  
  belongs_to :group, :counter_cache => 'games_count'

  belongs_to :home_team, :foreign_key => 'hometeam_id'
  belongs_to :away_team, :foreign_key => 'awayteam_id'
  

  validates_presence_of :group_id,
                        :on => :create, 
                        :message => "Must be associated with a group."
                        
  validates_length_of   :home_notes,
                        :maximum => 64, 
                        :message => "Must be 64 characters or less.",
                        :if => Proc.new { |g| !g.home_notes.nil? }
                        
  validates_length_of   :away_notes,
                        :maximum => 64, 
                        :message => "Must be 64 characters or less.",
                        :if => Proc.new { |g| !g.away_notes.nil? }
                        
  validates_each :played do |game, attr, value|
    if value && game.unplayable?
      game.errors.add attr, "Game can't be played as doesn't have home and away teams set."
    end
  end
  
  validates_each :hometeam_id, :awayteam_id do |game, attr, team_id|
    unless team_id.nil?   ||
           team_id == ''  ||
           team_id == 0 ||
           game.organisation.has_team_with_id?(team_id)
      game.errors.add attr, "Invalid team => '#{team_id}' (#{team_id == 0})."
    end
  end
  
  def organisation
    @organisation ||= self.group.stage.competition.season.organisation # !!!!
  end
  
  def unplayable?
    self.hometeam_id.nil? || self.awayteam_id.nil?
  end
  
  def playable?
    !unplayable?
  end

end
