class Organisation < ActiveRecord::Base
	
	attr_protected :id, :seasons_count
	
	belongs_to :sport
	has_many   :seasons, :dependent => true, :order => "id ASC"
	has_one    :current_season, :class_name => "Season", :order => "id asc"
	has_many   :teams, :dependent => true, :order => "title ASC"
	has_many   :notices, :dependent => true, :order => 'notices.created_on DESC'
	has_many   :pages, :dependent => true, :order => 'rank asc'
	
	before_validation :tidy_user_supplied_data!
	
	validates_presence_of   :summary, :message => 'You must enter something.'
	validates_uniqueness_of :id, :title, :nickname
	validates_format_of     :nickname, :with => /^[\sa-zA-Z0-9]{4,32}$/, :message => "Only use alpha numeric characters and spaces and ensure the nickname is betwen 4 and 32 characaters long."
	validates_format_of     :title, :with => /^[\s[:alpha:]]{4,64}$/, :message => "Only use alpha numeric characters and spaces and make sure the title is betwen 4 and 64 characters long."
	validates_exclusion_of  :nickname, :in => %w(www admin register join blog support), :message => "That's a reserved word, please try again."
	validates_length_of     :summary, :maximum => 512
	
	validates_presence_of   :sport_id
	
	# Return relevant organisation for a given url slug
	def self.find_by_url_slug(slug)
		Organisation.find :first, :conditions => ["lower(nickname) = ?", slug.gsub(/_/, ' ').downcase]
	end
	
	def find_team_by_url_slug(slug)
		self.teams.find :first, :conditions => ["lower(title) = ?", slug.gsub(/_/, ' ').downcase]
	end
	
	def find_notice_by_url_slug(slug)
		self.notices.find_first ["lower(heading) = ?", slug.gsub(/_/, ' ').downcase]
	end
	
	def find_page_by_url_slug(slug)
		self.pages.find_first ["lower(title) = ?", slug.gsub(/_/, ' ').downcase]
	end
	
	def recent_notices
	  self.notices.find(:all, :limit => 5, :include => :author)
	end
	
	def older_notices
	  self.notices.find(:all, :offset => 5, :limit => 5, :include => :author)
	end
	
	# Converts the organisation's nickname into a format suitable
	# for using in an URL. Currently this simply involves swapping
	# spaces for underscores. Other validation should ensure that
	# spaces are the only funny characters left by the time the
	# nickname is actually created.
	def to_param
		self.nickname.gsub(/\s/, '_').downcase
	end
	
	private
	
	# Tidies up user supplied data to cleanse it of common mistakes.
	# This is called when the organisation is saved.
	def tidy_user_supplied_data!
		self.title.strip!
		self.nickname.strip!
	end

end
