class Team < ActiveRecord::Base

  before_validation :strip_title!, :create_slug!
  after_validation  :move_slug_errors_to_title
  
  validates_presence_of   :title, :organisation_id
  validates_uniqueness_of :title, :scope => "organisation_id"
  validates_uniqueness_of :slug,  :scope => "organisation_id", :message => "Title is too similar to an existing one. Please change it."
  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
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
  
  def to_param
    self.slug
  end
  
private

  def create_slug!
    self.slug = self.title.to_url unless self.title.nil?
  end
  
  # As the slug field is auto generated we can't display its errors.
  # So, move them into the field the generation is based on instead.
  def move_slug_errors_to_title
    self.errors.add( :title, errors.on(:slug) )
  end
 
  def strip_title!
    self.title.strip! unless self.title.nil?
  end

end
