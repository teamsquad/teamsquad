class Match < ActiveRecord::Base
	belongs_to :group
	
	def has_notes?
		(!self.home_notes.nil? && self.home_notes!='') or (!self.away_notes.nil? && self.away_notes!='')
	end

	def has_summary?
		!self.summary.nil? && self.summary!=''			
	end
	
	def state
	  'toplay'
	end
	
	def pretty_date
		self.kickoff.strftime("%B %e")
	end
	
	def pretty_time
		self.kickoff.strftime("%H:%Mhrs")
	end
end