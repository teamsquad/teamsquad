class Page < ActiveRecord::Base
  
  attr_protected :organisation_id
  
  attr_accessor :remove_picture

  file_column :picture,
    :root_path => File.join(RAILS_ROOT, "public", "uploads"),
    :magick => { :geometry => "200x200>" }
  
  acts_as_list :scope => :organisation_id
  
  belongs_to :organisation
  
  before_validation :tidy_user_supplied_data!
  after_validation :remove_picture_if_required
  
  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of   :title, :content, :message => "You must enter something."
  validates_uniqueness_of :title, :scope => "organisation_id", :message => "You've already used that title, try something else."

  def to_param
    self.slug
  end

  def has_picture?
    (self.picture && self.picture.size > 0) || false
  end

private

  def tidy_user_supplied_data!
   self.slug = self.title.to_url unless self.title.nil?
  end
 
  def remove_picture_if_required
    if self.errors.empty? && !picture_just_uploaded? && remove_picture == 'true'
      self.picture = nil
    end
  end

end
