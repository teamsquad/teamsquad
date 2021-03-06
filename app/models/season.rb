# A season is basically a time based collection of data.
# Each organisation contains one or more seasons which in turn
# contain competitions (leagues, cups, etc.).
# Season's title must be unique within its parent organisation.

class Season < ActiveRecord::Base
  
  attr_protected :organisation_id, :stages_count
  
  acts_as_sluggable :title
  
  belongs_to :organisation, :counter_cache => 'seasons_count'
  has_many   :competitions, -> { order("position ASC") }, :dependent => :destroy
  
  before_validation :strip_title!
  
  validates_presence_of   :title, :organisation_id
  validates_format_of     :title, :with => /\A[\sa-zA-Z0-9\-]*\z/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_length_of     :title, :within => 4..64, :too_long => "Please use a shorter title.", :too_short => "Please use a longer title."
  validates_uniqueness_of :title, :scope => "organisation_id", :message => "You already have a season with that title. Try something else."
  validates_exclusion_of  :slug, :in => %w(competitions information notices help edit_season teams), :message => "That's a reserved word, please try again."
  validates_uniqueness_of :slug, :scope => "organisation_id", :message => "Too similar to an existing season. Please use something else."
 
  #
  # CLASS METHODS
  #
  
  def self.build_empty_season
    Season.new(
      :title => 'Empty'
    )
  end
  
  #
  # INSTANCE METHODS
  #
  
  def probably_not_yet_set_up
    self.title == 'Empty'
  end
  
  # Return relevant competition for a given url slug
  def find_competition(slug)
    self.competitions.where(slug: slug.downcase).first
  end
  
  def competitions_other_than(competition)
    self.competitions.where(["id != ?", competition.id])
  end
  
private
 
  def strip_title!
    self.title.strip! unless self.title.nil?
  end
  
end
