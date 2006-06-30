class Team < ActiveRecord::Base

  before_validation :tidy_user_supplied_data!
  
  validates_presence_of   :title
	validates_uniqueness_of :title, :scope => "organisation_id"
	validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."

  
  def to_param
    self.slug
  end
  
private

  def tidy_user_supplied_data!
    self.slug = self.title.to_url
  end

end
