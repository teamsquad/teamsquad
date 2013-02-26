class Competition < ActiveRecord::Base
  
  attr_protected :id, :season_id, :stages_count
  attr_accessor :format
  
  acts_as_sluggable :title
  
  before_validation :strip_title!
  before_create     :create_format
  
  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of   :title, :summary, :message => 'You must enter something'
  validates_uniqueness_of :title, :scope => [:season_id], :message => "Must be unique within a season."
  validates_length_of     :title, :within => 4..64
  validates_presence_of   :season_id, :on => :create, :message => "A competition must be associated with a season."
  validates_length_of     :label, :maximum => 32, :if => Proc.new { |c| !c.label.nil? }
  validates_uniqueness_of :slug, :scope => [:season_id], :message => 'Too similar to an existing title. Please alter the title.'
  validates_exclusion_of  :slug, :in => %w(new test about information fixtures results teams calendar news), :message => "That's a reserved word, please try again."

  acts_as_list :scope => :season

  belongs_to :season, :counter_cache => 'competitions_count'
  has_many   :stages, :dependent => :destroy, :order => "position ASC"
  
  def match_months
    GameMonth.find_by_sql "SELECT pretty_date, min(yyyymm) as yyyymm, min(date) as date FROM game_months WHERE competition_id = #{id} GROUP BY pretty_date ORDER BY min(yyyymm)"
  end
  
  def match_days
    GameDay.find_by_sql "SELECT pretty_date, min(yyyymm) as yyyymm, min(yyyymmdd) as yyyymmdd, min(date) as date FROM game_days WHERE competition_id = #{id} GROUP BY pretty_date ORDER BY min(yyyymmdd)"
  end
  
  has_many :fixture_months, 
    :class_name => 'GameMonth',
    :conditions => ["played = ?", false],
    :order => "date asc"
    
  has_many :result_months,
    :class_name => 'GameMonth',
    :conditions => ["played = ?", true],
    :order => "date desc"
    
  has_many :fixture_days, 
    :class_name => 'GameDay',
    :conditions => ["played = ?", false],
    :order => "date asc"
    
  has_many :result_days,
    :class_name => 'GameDay',
    :conditions => ["played = ?", true],
    :order => "date desc"
  
  has_many :matches,
    :include => [:home_team, :away_team, :group],
    :order => "kickoff asc"
  
  has_many :fixtures,
    :class_name => 'Match',
    :conditions => ["played = ?", false],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff asc"
  
  has_many :results,
    :class_name => 'Match',
    :conditions => ["played = ?", true],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff desc" 

  has_many :overdue_fixtures,
    :class_name => 'Match',
    :conditions => ["kickoff < CURRENT_DATE and played = ?", false],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff asc"
  
  has_many :recent_results,
    :class_name => 'Match',
    :conditions => ["kickoff > (CURRENT_DATE - 14) and played = ?", true],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff desc" 
  
  has_many :upcoming_fixtures,
    :class_name => 'Match',
    :conditions => ["kickoff < (CURRENT_DATE + 14) and played = ?", false],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff asc"
    
  has_many :news_worthy_matches,
    :class_name => 'Match',
    :conditions => ["kickoff > (CURRENT_DATE - 7) and played = ? AND hometeam_id != 0 AND awayteam_id != 0", true],
    :include => [:home_team, :away_team, :group],
    :order => "kickoff desc",
    :limit => 20
  
  def label_or_title
    (self.label && !self.label.empty?) ? self.label : self.title
  end
  
  def current_stage
    self.stages.find(
      :first,
      :include => :groups,
      :conditions => ["is_complete = ?", false]
    ) 
  end
  
  def find_stage(slug)
    self.stages.find(
      :first,
      :conditions => ["stages.slug = ?", slug.downcase]
      )
  end
  
  def match_days_for_month(date)
    self.match_days.select { |day| day.yyyymm == date.strftime("%Y%m") }
  end
  
  def matches_for_month(date)
    self.matches.find :all, :conditions => ["yyyymm = ?", date.strftime("%Y%m")]
  end
  
  def matches_for_day(date)
    self.matches.find :all, :conditions => ["yyyymmdd = ?", date.strftime("%Y%m%d")]
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
