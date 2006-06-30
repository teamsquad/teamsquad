class Page < ActiveRecord::Base
  
  attr_protected :organisation_id
  
  acts_as_list :scope => :organisation_id
  
  belongs_to :organisation
  
  before_validation :tidy_user_supplied_data!
  
  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of   :title, :content, :message => "You must enter something."
  validates_uniqueness_of :title, :scope => "organisation_id", :message => "You've already used that title, try something else."

  def to_param
    self.slug
  end
  
  # TODO: add protection here to handle nasty uploads and huge images etc.
  def upload=(incoming_file)
    if incoming_file.respond_to? "original_filename" and incoming_file.original_filename != ''
      original_filename = sanitize_filename(incoming_file.original_filename)
      filename = "#{self.organisation.id}-page-#{self.id}-#{original_filename}"
      store_upload(incoming_file, filename)
    end
  end
  
private

 def tidy_user_supplied_data!
   self.slug = self.title.to_url
 end
 
  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all non-alphanumeric, underscore or periods with underscores
    just_filename.sub(/[^\w\.\-]/,'_') 
  end
 
  def store_upload(file, filename)
    File.open("#{RAILS_ROOT}/public/uploads/#{filename}", "wb") do |f| 
      f.write(file.read)
    end
    self.picture = filename
  end

end
