class Team < ActiveRecord::Base

  before_validation :tidy_user_supplied_data!
  
  validates_presence_of   :title
	validates_uniqueness_of :title, :scope => "organisation_id"
	validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."

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
  
  def to_param
    self.slug
  end
  
private

  def tidy_user_supplied_data!
    self.slug = self.title.to_url
  end

end
