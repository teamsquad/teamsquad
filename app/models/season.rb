# A season is basically a time based collection of data.
# Each organisation contains one or more seasons which in turn
# contain competitions (leagues, cups, etc.).
# Season's title must be unique within its parent organisation.

class Season < ActiveRecord::Base
	
	attr_protected :id, :stages_count

	belongs_to :organisation, :counter_cache => 'seasons_count'
	has_many   :competitions, :dependent => true, :order => "rank ASC"

	before_validation :tidy_user_supplied_data!
	
	validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
	validates_length_of     :title, :within => 4..64, :too_long => "Please use a shorter title.", :too_short => "Please use a longer title."
	validates_uniqueness_of :title, :scope => "organisation_id"
	
	validates_presence_of   :organisation_id
	
	# Return relevant competition for a given url slug
	def find_competition_by_url_slug(slug)
		self.competitions.find_first ["lower(title) = ?", slug.gsub(/_/, ' ').downcase]
	end
	
	def competitions_other_than(competition)
	  self.competitions.find :all, :conditions => ["id != ?" ,competition.id]
	end
	
	# Converts the season's title into a format suitable for
	# using in an URL. Currently this simply involves swapping
	# spaces for underscores and removing everything else.
	def to_param
		self.title.gsub(/\s/, '_').downcase
	end
	
	private
	
	# Tidies up user supplied data to cleanse it of common mistakes.
	# This is called when the season is saved.
	def tidy_user_supplied_data!
		self.title.strip!
	end
	
end
