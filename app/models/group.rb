class Group < ActiveRecord::Base
	
	before_validation :tidy_user_supplied_data!

	validates_presence_of   :title
	validates_uniqueness_of :title, :scope => "stage_id"
	validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."

	belongs_to :stage, :counter_cache => 'groups_count'
	has_many   :games, :dependent => true
	has_many   :standings, :order => 'totalpoints desc'
	has_and_belongs_to_many :teams, :order => 'title asc'
	
	has_many   :fixtures, :class_name => 'Match'
	has_many   :results
	
	def remove_team!(team)
	  redundant_games = self.games.find(
	    :all,
	    :conditions => ["(hometeam_id = ? OR awayteam_id = ?)" , team.id, team.id]
	  )
	  self.transaction do
	    for game in redundant_games
	      game.destroy
	    end
	    team.destroy
	  end
	end
	
	def outstanding_results(limit=1000)
	  self.results.find(
	    :all,
	    :conditions => "kickoff < CURRENT_DATE",
	    :limit => limit
	  )
	end
	
	def has_outstanding_results?
	  self.outstanding_results(1).size == 1
	end

	# Converts the group's title into a format suitable for
	# using in an URL. Currently this simply involves swapping
	# spaces for underscores and removing everything else.
	def to_param
		self.title.gsub(/\s/, '_').downcase
	end
	
	def process_fixtures(params)
		self.transaction do
			matchday = "#{params['when']['year']}-#{params['when']['month']}-#{params['when']['day']}"
			params['game'].each do |gameparams|
				if gameparams[1]['hometeam']!="" && gameparams[1]['awayteam']!=""
					game = Game.new
					game.kickoff     = "#{matchday} #{gameparams[1]['hour']}:#{gameparams[1]['minute']}:00"
					game.hometeam_id = gameparams[1]['hometeam']
					game.awayteam_id = gameparams[1]['awayteam']
					self.games << game
				end
			end
		end
	end
	
	private
	
	# Tidies up user supplied data to cleanse it of common mistakes.
	# This is called when the group is saved.
	def tidy_user_supplied_data!
		self.title.strip!
	end
	
end
