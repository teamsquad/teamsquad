class Team < ActiveRecord::Base
	
	before_validation :tidy_user_supplied_data!
	
	validates_presence_of   :title
	validates_uniqueness_of :title, :scope => "organisation_id"
	validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
	
	belongs_to :organisation
	has_and_belongs_to_many :groups
	has_many :homegames, :class_name => "Game", :foreign_key => "hometeam_id", :dependent => true
	has_many :awaygames, :class_name => "Game", :foreign_key => "awayteam_id", :dependent => true
	
	def to_param
		self.title.gsub(/\s/, '_').downcase
	end
	
	private
	
	# Tidies up user supplied data to cleanse it of common mistakes.
	# This is called when the group is saved.
	def tidy_user_supplied_data!
		self.title.strip!
	end

end
