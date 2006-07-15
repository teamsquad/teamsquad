class Competition < ActiveRecord::Base
  
  attr_protected :id, :season_id
  
  attr_accessor :format
  
  before_validation :tidy_user_supplied_data!
  after_create :create_format
  
  validates_format_of    :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_presence_of  :title, :summary, :message => 'You must enter something'
  validates_length_of    :title, :within => 4..64
  validates_length_of    :label, :maximum => 32

  acts_as_list :scope => :season

  belongs_to :season, :counter_cache => 'competitions_count'
  has_many   :stages, :dependent => true, :order => "position ASC"
  
  has_many :match_months,
    :class_name => 'GameMonth',
    :finder_sql => 'SELECT pretty_date, min(yyyymm) as yyyymm, min(date) as date FROM game_months WHERE competition_id = #{id} GROUP BY pretty_date ORDER BY min(yyyymm)'
  
  has_many :match_days,
    :class_name => 'GameDay',
    :finder_sql => 'SELECT pretty_date, min(yyyymm) as yyyymm, min(yyyymmdd) as yyyymmdd, min(date) as date FROM game_days WHERE competition_id = #{id} GROUP BY pretty_date ORDER BY min(yyyymmdd)'

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
    :conditions => "(kickoff BETWEEN (CURRENT_DATE - 28) and (CURRENT_DATE + 4) AND hometeam_id != 0 AND awayteam_id != 0)",
    :include => [:home_team, :away_team, :group],
    :order => "kickoff desc"

  def to_param
    self.slug
  end
  
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
  
  # Attempts to save result data for this competitions fixtures
  # params argument is a set of well formed request parameters
  def process_results(params)
    self.transaction do
      params['game'].each do |key, attrs|
        game = Game.find(key)
        if attrs['home_points'] && attrs['away_points'] && attrs['home_points'] != "" && attrs['away_points'] != ""
          attrs = create_attributes_for_result_by_points(attrs)
        elsif attrs['home_score'] && attrs['away_score'] && attrs['home_score'] != "" && attrs['away_score'] != ""
          attrs = create_attributes_for_result_by_score(attrs)
        end
        if attrs['home_points'] && attrs['away_points'] && attrs['home_score'] && attrs['away_score'] 
          game.attributes = attrs
          game.played = true
          game.save or raise "Can't save game: #{game.errors.inspect}"
        end
      end
    end
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
    
    group = Group.new(
      :title => 'untitled'
    )
    
    self.stages << stage or raise "Can't add stage"
    stage.reload
    stage.groups << group or raise "Can't add group"
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

 def tidy_user_supplied_data!
   self.slug = self.title.to_url
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
  
  def create_attributes_for_result_by_points(attrs)
    if attrs['result'] == '0'
      attrs['home_score'] = 1
      attrs['away_score'] = 0
    elsif attrs['result'] == '1'
      attrs['home_score'] = 0
      attrs['away_score'] = 1
    elsif attrs['result'] == '2'
      attrs['home_score'] = 0
      attrs['away_score'] = 0
    end
    attrs.delete 'result'
    attrs
  end
  
  # TODO: needs to look points up from stage
  # In fact this should probably all be in stage model!
  def create_attributes_for_result_by_score(attrs)
     if attrs['home_score'] > attrs['away_score']
      attrs['home_points'] = 3
      attrs['away_points'] = 0
    elsif attrs['home_score'] < attrs['away_score']
      attrs['home_points'] = 0
      attrs['away_points'] = 3
    else
      attrs['home_points'] = 1
      attrs['away_points'] = 1
    end
    attrs
  end

end
