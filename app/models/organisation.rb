class Organisation < ActiveRecord::Base

  attr_accessor :remove_logo

  attr_accessible :title, :summary, :nickname, :sport_id

  file_column :logo,
    :root_path => File.join( Rails.root, "public", "uploads"),
    :magick => { :geometry => "48x48>" }

  belongs_to :sport
  has_many   :users,          -> { order('name asc') }, :dependent => :destroy
  has_many   :seasons,        -> { order("id ASC") }, :dependent => :destroy
  has_one    :current_season, -> { order("id asc") }, :class_name => "Season"
  has_many   :teams,          -> { order("title ASC") }, :dependent => :destroy
  has_many   :notices,        -> { order('notices.created_on DESC') }, :dependent => :destroy
  has_many   :recent_notices, -> { order('notices.created_on DESC') }
  has_many   :pages,          -> { order('position asc') }, :dependent => :destroy
  
  before_validation :tidy_user_supplied_data!
  after_validation :remove_logo_if_required

  validates_presence_of   :summary, :message => 'You must enter something.'
  validates_uniqueness_of :title, :nickname, :message => 'Sorry, already taken. Enter something else.'
  validates_format_of     :nickname, :with => /\A[a-zA-Z0-9]{3,32}\z/, :message => "Only use alpha numeric characters and ensure the nickname is betwen 3 and 32 characaters long."
  validates_format_of     :title, :with => /\A[\s[:alpha:]]{3,128}\z/, :message => "Only use alpha numeric characters and spaces and make sure the title is betwen 3 and 128 characters long."
  validates_exclusion_of  :nickname, :in => %w(w ww www wwww wwwwww admin register join blog support help mail official my our teams fixtures results news), :message => "That's a reserved word, please try again."
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
    Organisation.where(nickname: nickname.downcase).first
  end
  
  #
  # INSTANCE
  #

  def find_team(slug)
    self.teams.where(slug: slug.downcase).first
  end
  
  def has_team_with_id?(team_id)
    begin
      self.teams.find(team_id) ? true : false
    rescue
      false
    end
  end
  
  def find_notice(slug)
    self.notices.where(slug: slug.downcase).first
  end
  
  def find_page(slug)
    self.pages.where(slug: slug.downcase).first
  end
  
  def recent_notices
    self.notices.limit(4)
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
  
  def team_or_player
    self.sport.uses_teams ? 'team' : 'player'
  end
  
  def teams_or_players
    self.team_or_player + 's'
  end
  
  def has_archive?
    self.seasons.count > 1
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
