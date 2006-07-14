# A season is basically a time based collection of data.
# Each organisation contains one or more seasons which in turn
# contain competitions (leagues, cups, etc.).
# Season's title must be unique within its parent organisation.

class Season < ActiveRecord::Base
  
  attr_protected :organisation_id, :stages_count
  
  belongs_to :organisation, :counter_cache => 'seasons_count'
  has_many   :competitions, :dependent => true, :order => "position ASC"
  
  before_validation :tidy_user_supplied_data!
  
  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_length_of     :title, :within => 4..64, :too_long => "Please use a shorter title.", :too_short => "Please use a longer title."
  validates_uniqueness_of :title, :scope => "organisation_id", :message => "You already have a season with that title. Try something else."

  validates_presence_of   :organisation_id
  
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
  
  def to_param
    self.title
  end
  
  def probably_not_yet_set_up
    self.title == 'Empty'
  end
  
  # Return relevant competition for a given url slug
  def find_competition(slug)
    self.competitions.find :first, :conditions => ["slug = ?", slug.downcase]
  end
  
  def competitions_other_than(competition)
    self.competitions.find :all, :conditions => ["id != ?", competition.id]
  end
  
private

  def tidy_user_supplied_data!
    self.slug  = self.title.to_url
  end

end
