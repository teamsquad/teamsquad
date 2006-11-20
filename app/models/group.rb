class Group < ActiveRecord::Base
  
  attr_protected :stage_id
  
  acts_as_sluggable :title
  
  belongs_to :stage, :counter_cache => 'groups_count'
  has_many   :games, :dependent => true, :include => [:home_team, :away_team]
  has_many   :matches, :include => [:home_team, :away_team]
  has_many   :standings, :include => :team, :order => 'totalpoints desc'
  has_and_belongs_to_many :teams, :order => 'title asc'
  
  has_many :results,
    :class_name => 'Match',
    :conditions => ["played = ?", true],
    :order => "kickoff desc" 
  
  has_many :fixtures,
    :class_name => 'Match',
    :conditions => ["played = ?", false],
    :order => "kickoff asc"
  
  has_many :overdue_fixtures,
    :class_name => 'Match',
    :conditions => ["kickoff < CURRENT_DATE AND hometeam_id != 0 AND awayteam_id != 0 AND played = ?", false],
    :order => "kickoff asc"
  
  has_many :recent_results,
    :class_name => 'Match',
    :conditions => ["kickoff > (CURRENT_DATE - 14) and played = ?", true],
    :order => "kickoff desc" 
  
  has_many :upcoming_fixtures,
    :class_name => 'Match',
    :conditions => ["kickoff < (CURRENT_DATE + 14) and played = ?", false],
    :order => "kickoff asc"
  
  before_validation :strip_title!
  
  validates_presence_of   :title
  validates_uniqueness_of :title, :scope => "stage_id"
  validates_format_of     :title, :with => /^[\sa-zA-Z0-9\-]*$/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_length_of     :title, :within => 4..64
  validates_uniqueness_of :slug, :scope => "stage_id"
  validates_exclusion_of  :slug, :in => %w(new_group edit information notices help teams results fixtures calendar test), :message => "That's a reserved word, please try again."
  
  # A group is lonely if it is the only one within its parent stage
  def lonely?
    self.stage.groups_count == 1
  end
  
  def process_fixtures(params)
    self.transaction do
      matchday = "#{params['when']['year']}-#{params['when']['month']}-#{params['when']['day']}"
      params['game'].each do |gameparams|
        if gameparams[1]['hometeam']!="" && gameparams[1]['awayteam']!=""
          game = Game.new
          game.kickoff     = "#{matchday} #{gameparams[1]['hour']}:#{gameparams[1]['minute']}:00"
          game.hometeam_id = gameparams[1]['hometeam']
          game.awayteam_id = gameparams[1]['awayteam']
          self.games << game
        end
      end
    end
  end
  
  def class_for_position(position)
    if position <= (stage.automatic_promotion_places || 0)
      'auto-promote'
    elsif position <= (stage.automatic_promotion_places || 0) + (stage.conditional_promotion_places || 0)
      'conditional-promote'
    elsif position > (self.teams.size - (stage.automatic_relegation_places || 0))
      'auto-relegate'
    elsif position > (self.teams.size - ((stage.automatic_relegation_places || 0) + (stage.conditional_relegation_places || 0)))
      'conditional-relegate'
    else
      'safe'
    end
  end
  
private
  
  def strip_title!
    self.title.strip! unless self.title.nil?
  end
  
end
