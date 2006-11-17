class Notice < ActiveRecord::Base

  attr_accessor :remove_picture

  file_column :picture,
    :root_path => File.join(RAILS_ROOT, "public", "uploads"),
    :magick => { :geometry => "200x200>" }
  
  belongs_to :organisation
  has_many   :comments, :dependent => true, :order => 'comments.created_on ASC'
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  
  before_validation :strip_heading!, :create_slug!
  after_validation  :move_slug_errors_to_heading, :remove_picture_if_required

  validates_presence_of   :user_id, :organisation_id
  validates_format_of     :heading, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of   :heading, :content, :message => "You must enter something."
  validates_length_of     :heading, :in => 4..128
  validates_uniqueness_of :heading, :scope => "organisation_id", :message => "You already have a notice with this heading. Use something else."
  validates_uniqueness_of :slug,    :scope => "organisation_id", :message => "Heading is too similar to an existing notice. Please change it."

  def to_param
    self.slug
  end
  
  def has_picture?
    (self.picture && self.picture.size > 0) || false
  end
  
  def moderate_comments(params)
    return if params.nil? || params['comment'].nil?
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

  def create_slug!
    self.slug = self.heading.to_url unless self.heading.nil?
  end
  
  # As the slug field is auto generated we can't display its errors.
  # So, move them into the field the generation is based on instead.
  def move_slug_errors_to_heading
    self.errors.add( :heading, errors.on(:slug) )
  end
 
  def strip_heading!
    self.heading.strip! unless self.heading.nil?
  end
  
  def remove_picture_if_required
    if self.errors.empty? && !picture_just_uploaded? && remove_picture == 'true'
      self.picture = nil
    end
  end
 
end
