class Notice < ActiveRecord::Base
	
	belongs_to :organisation
	has_many   :comments, :dependent => true, :order => 'created_on ASC'
	belongs_to :author, :class_name => "User", :foreign_key => "user_id"

	validates_format_of     :heading, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
	validates_presence_of   :heading, :content, :message => "You must enter something."
	validates_uniqueness_of :heading, :scope => "organisation_id"
		
	def to_param
		self.heading.gsub(/\s/, '_').downcase
	end
	
	def save_from_params(params)
	  self.heading = params["heading"]
		self.content = params["content"]
		self.upload  = params["picture"]
		self.save
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
	
	def moderate_comments(params)
		self.transaction do
		  comments = self.comments
			params['comment'].each do |key, attrs|
				comment = comments.find(key) #TODO: check if many queries or gets from above
				if attrs['remove'] == "1"	
					comment.destroy
				else
					attrs.delete 'remove'
					comment.update_attributes(attrs)
				end
			end
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
