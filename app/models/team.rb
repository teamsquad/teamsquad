class Team < ActiveRecord::Base

  acts_as_sluggable :title
  
  attr_protected :organisation_id
  
  before_validation :strip_title!
  
  validates_presence_of   :title, :organisation_id
  validates_uniqueness_of :title, :scope => "organisation_id"
  validates_uniqueness_of :slug,  :scope => "organisation_id", :message => "Title is too similar to an existing one. Please change it."
  validates_format_of     :title, :with => /\A[\s\.a-zA-Z0-9\-]*\z/, :message => "You can only use alphanumeric characters, spaces, periods, and hyphens."
  validates_length_of     :title, :within => 4..64, :too_long => "Please use a shorter title.", :too_short => "Please use a longer title."
  
  has_many :fixture_days,
    -> { where(played: false).order("date asc") },
    :class_name => 'TeamGameDay'
    
  has_many :result_days,
    -> { where(played: true).order("date desc") },
    :class_name => 'TeamGameDay'
  
  has_many :matches,
    -> { includes(:home_team, :away_team, :group).order("kickoff asc") },
    :class_name => 'TeamMatch'
  
  has_many :fixtures,
    -> { where(played: false).includes(:home_team, :away_team, :group).order("kickoff asc") },
    :class_name => 'TeamMatch'
  
  has_many :results,
    -> { where(played: true).includes(:home_team, :away_team, :group).order("kickoff desc") },
    :class_name => 'TeamMatch'
    
  def competitions
    Competition.find_by_sql("SELECT c.* FROM competitions c JOIN stages s ON s.competition_id = c.id JOIN groups g ON g.stage_id = s.id JOIN groups_teams gt ON gt.group_id = g.id AND gt.team_id = #{id}")
  end
  
  def has_fixtures?
    !self.fixtures.empty?
  end
  
  def has_results?
    !self.results.empty?
  end
  
private
 
  def strip_title!
    self.title.strip! unless self.title.nil?
  end

end
