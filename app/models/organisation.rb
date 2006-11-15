class Organisation < ActiveRecord::Base

  attr_accessor :remove_logo

  file_column :logo,
    :root_path => File.join(RAILS_ROOT, "public", "uploads"),
    :magick => { :geometry => "48x48>" }

  belongs_to :sport
  has_many   :users, :dependent => true, :order => 'name asc'
  has_many   :seasons, :dependent => true, :order => "id ASC"
  has_one    :current_season, :class_name => "Season", :order => "id asc"
  has_many   :teams, :dependent => true, :order => "title ASC"
  has_many   :notices, :dependent => true, :include => :author, :order => 'notices.created_on DESC'
  has_many   :recent_notices, :include => :author, :order => 'notices.created_on DESC'
  has_many   :pages, :dependent => true, :order => 'position asc'
  
  before_validation :tidy_user_supplied_data!
  after_validation :remove_logo_if_required

  validates_presence_of   :summary, :message => 'You must enter something.'
  validates_uniqueness_of :title, :nickname, :message => 'Sorry, already taken. Enter something else.'
  validates_format_of     :nickname, :with => /^[a-zA-Z0-9]{3,32}$/, :message => "Only use alpha numeric characters and ensure the nickname is betwen 3 and 32 characaters long."
  validates_format_of     :title, :with => /^[\s[:alpha:]]{3,128}$/, :message => "Only use alpha numeric characters and spaces and make sure the title is betwen 3 and 128 characters long."
  validates_exclusion_of  :nickname, :in => %w(w ww www wwww wwwwww admin register join blog support test help mail), :message => "That's a reserved word, please try again."
  validates_length_of     :summary, :maximum => 512
  validates_presence_of   :sport_id

  #
  # CLASS
  #

  def self.register(organisation, user, invite)
    begin
      Organisation.transaction do
        season = Season.build_empty_season
        organisation_saved = organisation.save
        if organisation_saved
          user.organisation_id   = organisation.id
          season.organisation_id = organisation.id
        end
        user_saved   = user.save
        season_saved = season.save
        invite_ok    = Invite.use(invite)
        raise 'Rollback' unless organisation_saved && season_saved && user_saved && invite_ok
      end
      true
    rescue
      false
    end
  end

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
    self.nickname
  end
  
  def hint(name)
		@@hints[name]
	end
	
	def has_logo?
    (self.logo && self.logo.size > 0) || false
  end

private

  # Tidies up user supplied data to cleanse it of common mistakes.
  # This is called when the organisation is saved.
  def tidy_user_supplied_data!
    self.title.strip! unless self.title.nil?
    self.nickname.strip! unless self.nickname.nil?
  end
  
  def remove_logo_if_required
    if self.errors.empty? && !logo_just_uploaded? && remove_logo == 'true'
      self.logo = nil
    end
  end
  
  @@hints = {
		'title' => "Your organisation's name (e.g. The Football Association). You can't change this later so make sure you get it right. This must be unique so if someone else has already registered the name you want then you will have to think of something else.",
		'nickname' => "A shorter version of your organisation name that will be used to form the address of your website. This must be short, unique, and can't contain any funny characters or spaces.",
		'summary' => "Enter a short description of your organisation. Nothing too wordy.",
		'sport_id' => "Select the sport this organisation is for."
	}

end
