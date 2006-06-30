class Organisation < ActiveRecord::Base
  
  attr_protected :sport_id, :seasons_count
  
  belongs_to :sport
  has_many   :seasons, :dependent => true, :order => "id ASC"
  has_one    :current_season, :class_name => "Season", :order => "id asc"
  has_many   :teams, :dependent => true, :order => "title ASC"
  has_many   :notices, :dependent => true, :include => :author, :order => 'notices.created_on DESC'
  has_many   :recent_notices, :include => :author, :order => 'notices.created_on DESC'
  has_many   :pages, :dependent => true, :order => 'position asc'
  
  before_validation :tidy_user_supplied_data!

  validates_presence_of   :summary, :message => 'You must enter something.'
  validates_uniqueness_of :title, :nickname => 'Sorry, already taken. Enter something else.'
  validates_format_of     :nickname, :with => /^[a-zA-Z0-9]{4,32}$/, :message => "Only use alpha numeric characters and ensure the nickname is betwen 4 and 32 characaters long."
  validates_format_of     :title, :with => /^[\s[:alpha:]]{4,128}$/, :message => "Only use alpha numeric characters and spaces and make sure the title is betwen 4 and 128 characters long."
  validates_exclusion_of  :nickname, :in => %w(w ww www wwww wwwwww admin register join blog support), :message => "That's a reserved word, please try again."
  validates_length_of     :summary, :maximum => 512
  validates_presence_of   :sport_id

  #
  # CLASS
  #

  # Return relevant organisation for a given url slug
  def self.find_by_nickname(nickname)
    Organisation.find :first, :conditions => ["lower(nickname) = ?", nickname.downcase]
  end
  
  #
  # INSTANCE
  #

  def find_team(slug)
    self.teams.find(:first, :conditions => ["lower(slug) = ?", slug.downcase])
  end
  
  def find_notice(slug)
    self.notices.find(:first, :conditions => ["lower(slug) = ?", slug.downcase])
  end
  
  def find_page(slug)
    self.pages.find(:first, :conditions => ["lower(slug) = ?", slug.downcase])
  end
  
  def recent_notices
    self.notices.find(:all, :limit => 5)
  end
  
  def older_notices
    self.notices.find(:all, :offset => 5, :limit => 5)
  end
  
  def to_param
    self.slug
  end

private

  # Tidies up user supplied data to cleanse it of common mistakes.
  # This is called when the organisation is saved.
  def tidy_user_supplied_data!
    self.title.strip!
    self.nickname.strip!
  end

end
