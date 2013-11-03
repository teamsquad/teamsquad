class Competition < ActiveRecord::Base
  
  attr_protected :id, :season_id, :stages_count
  attr_accessor :format
  
  acts_as_sluggable :title
  
  before_validation :strip_title!
  before_create     :create_format
  
  validates_format_of     :title, :with => /\A[\sa-zA-Z0-9\-]*\z/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of   :title, :summary, :message => 'You must enter something'
  validates_uniqueness_of :title, :scope => [:season_id], :message => "Must be unique within a season."
  validates_length_of     :title, :within => 4..64
  validates_presence_of   :season_id, :on => :create, :message => "A competition must be associated with a season."
  validates_length_of     :label, :maximum => 32, :if => Proc.new { |c| !c.label.nil? }
  validates_uniqueness_of :slug, :scope => [:season_id], :message => 'Too similar to an existing title. Please alter the title.'
  validates_exclusion_of  :slug, :in => %w(new test about information fixtures results teams calendar news), :message => "That's a reserved word, please try again."

  acts_as_list :scope => :season

  belongs_to :season, :counter_cache => 'competitions_count'
  has_many   :stages, -> { order("position ASC") }, :dependent => :destroy
  
  def match_months
    GameMonth.find_by_sql "SELECT pretty_date, min(yyyymm) as yyyymm, min(date) as date FROM game_months WHERE competition_id = #{id} GROUP BY pretty_date ORDER BY min(yyyymm)"
  end
  
  def match_days
    GameDay.find_by_sql "SELECT pretty_date, min(yyyymm) as yyyymm, min(yyyymmdd) as yyyymmdd, min(date) as date FROM game_days WHERE competition_id = #{id} GROUP BY pretty_date ORDER BY min(yyyymmdd)"
  end
  
  has_many :fixture_months,
    -> { where(played: false).order("date asc") },
    :class_name => 'GameMonth'
    
  has_many :result_months,
    -> { where(played: true).order("date desc") },
    :class_name => 'GameMonth'
    
  has_many :fixture_days,
    -> { where(played: false).order("date asc") },
    :class_name => 'GameDay'
    
  has_many :result_days,
    -> { where(played: true).order("date desc") },
    :class_name => 'GameDay'
    
  has_many :matches,
    -> { includes(:home_team, :away_team, :group).order("kickoff asc") }
    
  has_many :fixtures,
    -> { where(played: false).includes(:home_team, :away_team, :group).order("kickoff asc") },
    :class_name => 'Match'
    
  has_many :results,
    -> { where(played: true).includes(:home_team, :away_team, :group).order("kickoff desc") },
    :class_name => 'Match'
    
  has_many :overdue_fixtures,
    -> { where("kickoff < CURRENT_DATE and played = false").includes(:home_team, :away_team, :group).order("kickoff asc") },
    :class_name => 'Match'
    
  has_many :recent_results,
    -> { where("kickoff > (CURRENT_DATE - 14) and played = true").includes(:home_team, :away_team, :group).order("kickoff desc") },
    :class_name => 'Match'
    
  has_many :upcoming_fixtures,
    -> { where("kickoff < (CURRENT_DATE + 14) and played = false").includes(:home_team, :away_team, :group).order("kickoff asc") },
    :class_name => 'Match'
    
  has_many :news_worthy_matches,
    -> { where("kickoff > (CURRENT_DATE - 14) and played = true AND hometeam_id != 0 AND awayteam_id != 0").includes(:home_team, :away_team, :group).order("kickoff desc").limit(20) },
    :class_name => 'Match'
    
  def label_or_title
    (self.label && !self.label.empty?) ? self.label : self.title
  end
  
  def current_stage
    self.stages.where(is_complete: false).includes(:groups).first
  end
  
  def find_stage(slug)
    self.stages.where(slug: slug.downcase).first
  end
  
  def match_days_for_month(date)
    self.match_days.select { |day| day.yyyymm == date.strftime("%Y%m") }
  end
  
  def matches_for_month(date)
    self.matches.where(yyyymm: date.strftime("%Y%m"))
  end
  
  def matches_for_day(date)
    self.matches.where(yyyymmdd: date.strftime("%Y%m%d"))
  end
  
  def has_news_worthy_matches?
    self.news_worthy_matches.count > 0
  end
  
  def number_of_teams
    count = 0
    self.stages.each do |stage|
      stage.groups.each do |group|
        count += group.teams.count
      end
    end
    count
  end
  
protected
  
  # Saves the competition and creates appropriate
  # underlying stages and groups as determined
  # by self.format. Formats are currently hardcoded
  # but should really be made more extensible.
  def create_format
    self.transaction do
      if self.format == "0"
        self.create_empty_league
      elsif self.format == "1"
        self.create_simple_league
      elsif self.format == "2"
        self.create_playoff_league
      elsif self.format == "3"
        self.create_8team_cup
      end
    end
  end
  
  # Create an empty league with no stages or groups
  def create_empty_league
    # no op
  end

  # Create a league with just one stage containing one group
  def create_simple_league
    stage = Stage.new(
      :title => 'Table',
      :position => 1,
      :is_knockout => false
    )
    stage.groups << Group.new( :title => 'untitled' )
    self.stages << stage
  end

  def create_playoff_league
    raise "not implemented yet"
  end

  def create_8team_cup
    raise "not implemented yet"
  end

  def create_16team_cup
    raise "not implemented yet"
  end

  def create_32team_cup
    raise "not implemented yet"
  end

  def create_tournament
    raise "not implemented yet"
  end

private
  
  def strip_title!
    self.title.strip! unless self.title.nil?
  end
  
  def self.formats
    [
      ["Empty - will need to be manually set up after creation", "0"],
      ["League", "1"],
      ["League with one play-off stage", "2"],
      ["Cup - 8 teams, 4 stages", "3"],
      ["Cup - 16 teams, 5 stages", "4"],
      ["Cup - 32 teams, 6 stages", '5'],
      ["Tournament - 32 teams, 1 group stage, 5 knockout stages", "6"],
    ]
  end
  
end
