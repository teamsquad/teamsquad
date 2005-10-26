class Competition < ActiveRecord::Base
	
	attr_protected :id, :season_id
	
	attr_accessor :format
	
	before_validation :tidy_user_supplied_data!
	
	validates_format_of    :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
	validates_exclusion_of :title, :in => %w(recent contact information archive), :message => "That's a reserved word, please try again."
	validates_presence_of  :title, :summary, :message => 'You must enter something'
	
	acts_as_list :column => 'rank', :scope => :season
	
	belongs_to :season, :counter_cache => 'competitions_count'
	has_many   :stages, :dependent => true, :order => "rank ASC"
		
	# Return relevant stage for a given url slug
	def find_stage_by_url_slug(slug)
		self.stages.find :first, :conditions => ["lower(title) = ?", slug.gsub(/_/, ' ').downcase]
	end
	
	# Converts the competition's title into a format suitable for
	# using in an URL. Currently this simply involves swapping
	# spaces for underscores and removing everything else.
	def to_param
		self.title.gsub(/\s/, '_').downcase
	end
	
  # Attempts to save result data for this competitions fixtures
  # params argument is a set of well formed request parameters
  def process_results(params)
	  self.transaction do
  		params['game'].each do |key, value|
  			if value['home_points']!="" and value['away_points']!=""
  				game = Game.find(key)
  				if !game.nil? && value['result'] != '-1'
  					if value['result'] == '0'
  						value['home_score'] = 1
  						value['away_score'] = 0
  					elsif value['result'] == '1'
  						value['home_score'] = 0
  						value['away_score'] = 1
  					elsif value['result'] == '2'
  						value['home_score'] = 0
  						value['away_score'] = 0
  					end
  					if value['home_score'] && value['away_score'] && value['home_score'] !='' && value['away_score'] != ''
  					  value.delete 'result'
  					  game.attributes = value
  					  game.played = true
  					  game.save
  					end
  				end
  			end
  		end
  	end
	end
	
	# Saves the competition and creates appropriate
	# underlying stages and groups as determined
	# by self.format. Formats are currently hardcoded
	# but should probably be made more extensible.
	def save_with_format
		self.transaction do
			if self.format == "0"
				self.create_empty_league
			elsif self.format == "1"
				self.create_simple_league
			elsif self.format == "2"
				self.create_playoff_league
			elsif self.format == "3"
				self.create_8team_cup
			end
		end
	end

	protected
	
	# Create an empty league with no stages or groups
	def create_empty_league
		self.save
	end
	
	# Create a league with just one stage containing one group
	def create_simple_league
		stage = Stage.new(
			:title => 'Table',
			:rank => 1,
			:is_knockout => false
		)
		group = Group.new(
			:title => 'untitled'
		)
		stage.groups << group or raise "Can't add group"
		self.stages << stage or raise "Can't add stage"
		self.save
	end
	
	def create_playoff_league
		raise "not supported"
	end
	
	def create_8team_cup
		raise "not supported"
	end
	
	def create_16team_cup
		raise "not supported"
	end
	
	def create_32team_cup
		raise "not supported"
	end
	
	def create_tournament
		raise "not supported"
	end
	
	# Tidies up user supplied data to cleanse it of common mistakes.
	# This is called when the competition is saved.
	def tidy_user_supplied_data!
		self.title.strip!
	end

  private
  
  def self.formats
		[
			["Empty - will need to be manually set up after creation", "0"],
			["League - no stages, one group", "1"],
			["League - one play-off stage", "2"],
			["Cup - 8 teams, 4 stages", "3"],
			["Cup - 16 teams, 5 stages", "4"],
			["Cup - 32 teams, 6 stages", '5'],
			["Tournament - 32 teams, 1 group stage, 5 knockout stages", "6"],
		]
	end
end
