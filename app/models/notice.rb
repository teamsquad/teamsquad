# encoding: utf-8

class Notice < ActiveRecord::Base

  attr_accessor :remove_picture
  attr_protected :organisation_id, :user_id

  acts_as_sluggable :heading

  file_column :picture,
    :root_path => File.join( Rails.root, "public", "uploads"),
    :max_file_size => 20.kilobytes,
    :magick => { :geometry => "200x200>" }
  
  belongs_to :organisation
  has_many   :comments, :dependent => :destroy, :order => 'comments.created_on ASC'
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  
  before_validation :strip_heading!
  after_validation  :remove_picture_if_required

  validates_presence_of    :user_id, :organisation_id
  validates_format_of      :heading, :with => /^[\s\'\!\&£\$\,a-zA-Z0-9\-]*$/, :message => "Hey, no funny characters. Just a few standard bits of punctuation allowed."
  validates_presence_of    :heading, :content, :message => "You must enter something."
  validates_length_of      :heading, :in => 4..128
  validates_uniqueness_of  :heading, :scope => "organisation_id", :message => "You already have a notice with this heading. Use something else."
  validates_uniqueness_of  :slug,    :scope => "organisation_id", :message => "Heading is too similar to an existing notice. Please change it."
  
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
 
  def strip_heading!
    self.heading.strip! unless self.heading.nil?
  end
  
  def remove_picture_if_required
    if self.errors.empty? && !picture_just_uploaded? && remove_picture == 'true'
      self.picture = nil
    end
  end
 
end
