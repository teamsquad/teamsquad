class Page < ActiveRecord::Base
  
  belongs_to :organisation
	acts_as_list :scope => :organisation, :column => 'rank'

  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
	validates_presence_of   :title, :content, :message => "You must enter something."
	validates_uniqueness_of :title, :scope => "organisation_id"

  # Converts the page's title into a format suitable for
	# using in an URL. Currently this simply involves swapping
	# spaces for underscores and removing everything else.
	def to_param
		self.title.gsub(/\s/, '_').downcase
	end
	
	def upload=(incoming_file)
		if incoming_file.respond_to? "original_filename" and incoming_file.original_filename != ''
   		@filename = sanitize_filename incoming_file.original_filename
   		@content_type = incoming_file.content_type
   		@file = incoming_file
		end
	end

	def before_save
		if @file
    	File.open("#{RAILS_ROOT}/public/uploads/#{@filename}", "wb") do |f| 
    		f.write(@file.read)
    	end
			self.picture = @filename
	  end
	end

	private

	def sanitize_filename(file_name)
		# get only the filename, not the whole path (from IE)
		just_filename = File.basename(file_name) 
		# replace all non-alphanumeric, underscore or periods with underscores
		just_filename.sub(/[^\w\.\-]/,'_') 
	end

end
