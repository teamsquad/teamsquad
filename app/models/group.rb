class Group < ActiveRecord::Base
  
  attr_protected :stage_id
  
  acts_as_sluggable :title
  
  belongs_to :stage, :counter_cache => 'groups_count'
  has_many   :games, -> { includes(:home_team, :away_team) }, :dependent => :destroy
  has_many   :matches, -> { includes(:home_team, :away_team) }
  has_many   :standings, -> { includes(:team).order('totalpoints desc') }
  has_and_belongs_to_many :teams, -> { order('title asc') }
  
  has_many :results,
    -> { where(played: true).order("kickoff desc") },
    :class_name => 'Match'
  
  has_many :fixtures,
    -> { where(played: false).order("kickoff asc") },
    :class_name => 'Match'
  
  has_many :overdue_fixtures,
    -> { where("kickoff < CURRENT_DATE AND hometeam_id != 0 AND awayteam_id != 0 AND played = false").order("kickoff asc") },
    :class_name => 'Match'
    
  has_many :recent_results,
    -> { where("kickoff > (CURRENT_DATE - 14) and played = true").order("kickoff desc") },
    :class_name => 'Match'
  
  has_many :upcoming_fixtures,
    -> { where("kickoff < (CURRENT_DATE + 14) and played = false").order("kickoff asc") },
    :class_name => 'Match'
  
  before_validation :strip_title!
  
  validates_presence_of   :title
  validates_uniqueness_of :title, :scope => "stage_id"
  validates_format_of     :title, :with => /\A[\sa-zA-Z0-9\-]*\z/, :message => "Only use alpha numeric characters, spaces or hyphens."
  validates_length_of     :title, :within => 4..64
  validates_uniqueness_of :slug, :scope => "stage_id"
  validates_exclusion_of  :slug, :in => %w(new_group edit information notices help teams results fixtures calendar test), :message => "That's a reserved word, please try again."
  
  def has_teams?
    !self.teams.empty?
  end
  
  def has_overdue_fixtures?
    !self.overdue_fixtures.empty?
  end
  
  # A group is lonely if it is the only one within its parent stage
  def lonely?
    self.stage.groups_count == 1
  end
  
  def process_fixtures(params)
    self.transaction do
      matchday = "#{params['when']['year']}-#{params['when']['month']}-#{params['when']['day']}"
      params['game'].each do |gameparams|
        game = self.games.build
        game.kickoff     = "#{matchday} #{gameparams[1]['hour']}:#{gameparams[1]['minute']}:00"
        game.hometeam_id = gameparams[1]['hometeam']
        game.awayteam_id = gameparams[1]['awayteam']
        game.save or raise "Rollback!"
      end
    end
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
      attrs['home_points'] = self.stage.points_for_win
      attrs['away_points'] = self.stage.points_for_loss
    elsif attrs['home_score'] < attrs['away_score']
      attrs['home_points'] = self.stage.points_for_loss
      attrs['away_points'] = self.stage.points_for_win
    else
      attrs['home_points'] = self.stage.points_for_draw
      attrs['away_points'] = self.stage.points_for_draw
    end
    attrs
  end
  
end
