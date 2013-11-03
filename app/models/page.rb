class Page < ActiveRecord::Base
  
  attr_protected :organisation_id
  attr_accessor  :remove_picture

  file_column :picture,
    :root_path => File.join(Rails.root, "public", "uploads"),
    :magick => { :geometry => "200x200>" }
  
  acts_as_sluggable :title
  acts_as_list      :scope => :organisation_id
  
  belongs_to :organisation
  
  before_validation :strip_title!
  after_validation  :remove_picture_if_required
  
  validates_presence_of   :organisation_id
  validates_format_of     :title, :with => /\A[\sa-zA-Z0-9\-]*\z/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of   :title, :content, :message => "You must enter something."
  validates_uniqueness_of :title, :scope => "organisation_id", :message => "You've already used that title, try something else."
  validates_uniqueness_of :slug,  :scope => "organisation_id", :message => "Title is too similar to an existing one. Please change it."
  validates_length_of     :title, :within => 4..128
  validates_length_of     :label, :maximum => 32, :if => Proc.new { |p| !p.label.nil? }
  
  def label_or_title
    (self.label && !self.label.empty?) ? self.label : self.title
  end
  
  def has_picture?
    (self.picture && self.picture.size > 0) || false
  end
  
private
  
  def strip_title!
    self.title.strip! unless self.title.nil?
  end
  
  def remove_picture_if_required
    if self.errors.empty? && !picture_just_uploaded? && remove_picture == 'true'
      self.picture = nil
    end
  end
  
end
