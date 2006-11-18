class Stage < ActiveRecord::Base

  attr_protected :competition_id
  
  acts_as_sluggable :title
  acts_as_list :scope => :competition

  belongs_to :competition, :counter_cache => 'stages_count'
  has_many   :groups, :dependent => true, :order => "title ASC"

  has_many :results,
    :class_name => 'Match',
    :conditions => ["played = ?", true],
    :order => "kickoff desc" 

  has_many :fixtures,
    :class_name => 'Match',
    :conditions => ["played = ?", false],
    :order => "kickoff asc"

  has_many :overdue_fixtures,
    :class_name => 'Match',
    :conditions => ["kickoff < CURRENT_DATE and played = ?", false],
    :order => "kickoff asc"
  
  has_many :recent_results,
    :class_name => 'Match',
    :conditions => ["kickoff > (CURRENT_DATE - 14) and played = ?", true],
    :order => "kickoff desc" 
  
  has_many :upcoming_fixtures,
    :class_name => 'Match',
    :conditions => ["kickoff < (CURRENT_DATE + 14) and played = ?", false],
    :order => "kickoff asc"

  before_validation :strip_title!
  
  validates_presence_of   :title
  validates_uniqueness_of :title, :scope => "competition_id", :message => "You already have a stage with that name in this competition."
  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_length_of     :title, :within => 4..64, :too_long => "Please use a shorter title.", :too_short => "Please use a longer title."
  validates_exclusion_of  :slug,  :in => %w(edit_stage calendar fixtures results new_stage teams calendar information about), :message => "That's a reserved word, please try again."
  validates_uniqueness_of :slug,  :scope => "competition_id", :message => "Title is too similar to an existing one. Please change it."

  
  def has_no_groups?
    !self.has_groups?
  end
  
  def has_games?
    has_fixtures? or has_results?
  end
  
  # A stage is lonely if it is the only one within its parent competition
  def lonely?
    self.competition.stages_count == 1
  end
  
  # Return relevant group for a given url slug
  def find_group(slug)
    self.groups.find :first, :conditions => ["slug = ?", slug.downcase]
  end
  
private
  
  def strip_title!
    self.title.strip! unless self.title.nil?
  end
  
end
