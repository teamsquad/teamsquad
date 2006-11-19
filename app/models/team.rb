class Team < ActiveRecord::Base

  acts_as_sluggable :title
  
  before_validation :strip_title!
  
  validates_presence_of   :title, :organisation_id
  validates_uniqueness_of :title, :scope => "organisation_id"
  validates_uniqueness_of :slug,  :scope => "organisation_id", :message => "Title is too similar to an existing one. Please change it."
  validates_format_of     :title, :with => /^[\s\.a-zA-Z0-9\-]*$/, :message => "You can only use alphanumeric characters, spaces, periods, and hyphens."
  validates_length_of     :title, :within => 4..64, :too_long => "Please use a shorter title.", :too_short => "Please use a longer title."
  
  has_many :fixture_days, 
    :class_name => 'TeamGameDay',
    :conditions => ["played = ?", false],
    :order => "date asc"
    
  has_many :result_days,
    :class_name => 'TeamGameDay',
    :conditions => ["played = ?", true],
    :order => "date desc"
  
  has_many :matches,
    :class_name => 'TeamMatch',
    :include => [:home_team, :away_team, :group],
    :order => "kickoff asc"
  
  has_many :fixtures,
    :class_name => 'TeamMatch',
    :conditions => ["played = ?", false],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff asc"
  
  has_many :results,
    :class_name => 'TeamMatch',
    :conditions => ["played = ?", true],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff desc"
    
  has_many :competitions,
    :finder_sql => 'SELECT c.* FROM competitions c JOIN stages s ON s.competition_id = c.id JOIN groups g ON g.stage_id = s.id JOIN groups_teams gt ON gt.group_id = g.id AND gt.team_id = #{id}'
  
private
 
  def strip_title!
    self.title.strip! unless self.title.nil?
  end

end
