class Stage < ActiveRecord::Base
	
	before_validation :tidy_user_supplied_data!
	
	validates_presence_of   :title
	validates_uniqueness_of :title, :scope => "competition_id"
	validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."

	acts_as_list :column => 'rank', :scope => :competition
	
	belongs_to :competition, :counter_cache => 'stages_count'
	has_many   :groups, :dependent => true, :order => "title ASC"
	
	has_many   :fixtures, :finder_sql =>
      'SELECT DISTINCT f.* ' +
      'FROM groups g ' +
      'JOIN fixtures f ON f.group_id = g.id ' +
      'WHERE g.stage_id = #{id}'
      
  has_many   :results, :finder_sql =>
      'SELECT DISTINCT r.* ' +
      'FROM groups g ' +
      'JOIN results r ON r.group_id = g.id ' +
      'WHERE g.stage_id = #{id}'
	
	# Return relevant group for a given url slug
	def find_group_by_url_slug(slug)
		self.groups.find :first, :conditions => ["lower(title) = ?", slug.gsub(/_/, ' ').downcase]
	end
	
	# Converts the stages's title into a format suitable for
	# using in an URL. Currently this simply involves swapping
	# spaces for underscores and removing everything else.
	def to_param
		self.title.gsub(/\s/, '_').downcase
	end	
	
	def groups_with_results 
	  self.groups.find(:all, :include => :results).select { |group| group.results.size != 0}
	end
	
	def groups_with_fixtures 
	  self.groups.find(:all, :include => :fixtures).select { |group| group.fixtures.size != 0}
	end
	
	private
	
	# Tidies up user supplied data to cleanse it of common mistakes.
	# This is called when the stage is saved.
	def tidy_user_supplied_data!
		self.title.strip!
	end

end
