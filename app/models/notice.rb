class Notice < ActiveRecord::Base
  
  attr_accessor :upload
  
  belongs_to :organisation
  has_many   :comments, :dependent => true, :order => 'comments.created_on ASC'
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  
  before_validation :tidy_user_supplied_data!

  validates_format_of     :heading, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of   :heading, :content, :message => "You must enter something."
  validates_uniqueness_of :heading, :scope => "organisation_id", :message => "You already have a notice with this heading. Use something else."
  
  # TODO: add protection here to handle nasty uploads and huge images etc.
  def upload=(incoming_file)
    if incoming_file.respond_to? "original_filename" and incoming_file.original_filename != ''
      original_filename = sanitize_filename(incoming_file.original_filename)
      filename = "notice-#{Time.now}-#{original_filename}"
      store_upload(incoming_file, filename)
    end
  end

  def to_param
    self.slug
  end
  
  def has_picture?
    (self.picture && self.picture.size > 0) or false
  end
  
private

  def tidy_user_supplied_data!
   self.slug = self.heading.to_url
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
