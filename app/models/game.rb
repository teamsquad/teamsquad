class Game < ActiveRecord::Base
	
	belongs_to :group
	belongs_to :hometeam, :class_name => "Team", :foreign_key => "hometeam_id"
	belongs_to :awayteam, :class_name => "Team", :foreign_key => "awayteam_id"
	
	def has_notes?
		(!self.home_notes.nil? && self.home_notes!='') or (!self.away_notes.nil? && self.away_notes!='')
	end

	def has_summary?
		!self.summary.nil? && self.summary!=''			
	end
	
	def state
		if self.played
			if self.home_points > self.away_points
				'homewin'
			elsif self.home_points < self.away_points
				'awaywin'
			else
				'draw'
			end
		else
			'toplay'
		end
	end
	
	def pretty_date
		self.kickoff.strftime("%B %e %Y")
	end
	
	def pretty_time
		self.kickoff.strftime("%H:%Mhrs")
	end
end