class CreateCoreStructure < ActiveRecord::Migration
    
  def self.up
    create_table "sports", :force => true do |t|
      t.column "title", :string, :limit => 64, :null => false
      t.column "uses_scores", :boolean, :default => true
      t.column "uses_manual_points", :boolean, :default => false
      t.column "uses_teams", :boolean, :default => true
      t.column "uses_kits", :boolean, :default => true
    end
    add_index "sports", ["title"], :name => "sports_title_key", :unique => true
    
    create_table "organisations", :force => true do |t|
      t.column "sport_id", :integer
      t.column "title", :string, :limit => 128, :null => false
      t.column "nickname", :string, :limit => 32, :null => false
      t.column "summary", :string, :limit => 512, :null => false
      t.column "theme", :string, :limit => 32, :default => 'classic'
      t.column "seasons_count", :integer, :default => 0
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "logo", :string, :limit => 200
    end
    add_index "organisations", ["nickname"], :name => "organisations_nickname_key", :unique => true
    add_index "organisations", ["sport_id"], :name => "organisations_sport_id"
    add_index "organisations", ["title"], :name => "organisations_title_key", :unique => true

    create_table "users", :force => true do |t|
      t.column "organisation_id", :integer
      t.column "email", :string, :limit => 256, :null => false
      t.column "password", :string, :limit => 256, :null => false
      t.column "name", :string, :limit => 128, :null => false
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "users", ["email"], :name => "users_email_key", :unique => true
    add_index "users", ["organisation_id"], :name => "users_organisation_id"
  
    create_table "notices", :force => true do |t|
      t.column "organisation_id", :integer
      t.column "user_id", :integer
      t.column "heading", :string, :limit => 128, :null => false
      t.column "slug", :string, :limit => 128, :null => false
      t.column "content", :text, :null => false
      t.column "picture", :string, :limit => 256
      t.column "comments_count", :integer, :default => 0
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "notices", ["organisation_id"], :name => "notices_organisation_id"
    add_index "notices", ["organisation_id", "heading"], :name => "notices_organisation_id_key", :unique => true
    add_index "notices", ["organisation_id", "slug"], :name => "notices_organisation_id_key1", :unique => true

    create_table "comments", :force => true do |t|
      t.column "notice_id", :integer
      t.column "name", :string, :limit => 128
      t.column "content", :text, :null => false
      t.column "ip_address", :string, :limit => 16
      t.column "user_agent", :string, :limit => 128
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "comments", ["notice_id"], :name => "comments_notice_id"
  
    create_table "pages", :force => true do |t|
      t.column "organisation_id", :integer
      t.column "title", :string, :limit => 128, :null => false
      t.column "slug", :string, :limit => 128, :null => false
      t.column "content", :text, :null => false
      t.column "picture", :string, :limit => 256
      t.column "position", :integer, :null => false
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "label", :string, :limit => 32
    end
    add_index "pages", ["organisation_id"], :name => "pages_organisation_id"
    add_index "pages", ["organisation_id", "title"], :name => "pages_organisation_id_key", :unique => true
    add_index "pages", ["organisation_id", "slug"], :name => "pages_organisation_id_key1", :unique => true

    create_table "teams", :force => true do |t|
      t.column "organisation_id", :integer
      t.column "title", :string, :limit => 64, :null => false
      t.column "slug", :string, :limit => 128, :null => false
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "teams", ["organisation_id"], :name => "teams_organisation_id"
    add_index "teams", ["organisation_id", "title"], :name => "teams_organisation_id_key", :unique => true
    add_index "teams", ["organisation_id", "slug"], :name => "teams_organisation_id_key1", :unique => true

    create_table "seasons", :force => true do |t|
      t.column "organisation_id", :integer
      t.column "title", :string, :limit => 64, :null => false
      t.column "slug", :string, :limit => 128, :null => false
      t.column "competitions_count", :integer, :default => 0
      t.column "is_complete", :boolean, :default => false
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "seasons", ["organisation_id"], :name => "seasons_organisation_id"
    add_index "seasons", ["organisation_id", "title"], :name => "seasons_organisation_id_key", :unique => true
    add_index "seasons", ["organisation_id", "slug"], :name => "seasons_organisation_id_key1", :unique => true

    create_table "competitions", :force => true do |t|
      t.column "season_id", :integer
      t.column "title", :string, :limit => 64, :null => false
      t.column "slug", :string, :limit => 128, :null => false
      t.column "summary", :text
      t.column "position", :integer, :default => 1
      t.column "stages_count", :integer, :default => 0
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
      t.column "label", :string, :limit => 32
    end
    add_index "competitions", ["season_id"], :name => "competitions_season_id"
    add_index "competitions", ["season_id", "title"], :name => "competitions_season_id_key", :unique => true
    add_index "competitions", ["slug", "season_id"], :name => "competitions_season_id_key1", :unique => true
    add_index "competitions", ["position", "season_id"], :name => "competitions_season_id_key2", :unique => true

    create_table "stages", :force => true do |t|
      t.column "competition_id", :integer
      t.column "title", :string, :limit => 64, :null => false
      t.column "slug", :string, :limit => 128, :null => false
      t.column "position", :integer, :default => 1
      t.column "groups_count", :integer, :default => 0
      t.column "automatic_promotion_places", :integer
      t.column "conditional_promotion_places", :integer
      t.column "automatic_relegation_places", :integer
      t.column "conditional_relegation_places", :integer
      t.column "is_knockout", :boolean, :default => false
      t.column "is_complete", :boolean, :default => false
      t.column "points_for_win", :integer, :default => 3
      t.column "points_for_draw", :integer, :default => 1
      t.column "points_for_loss", :integer, :default => 0
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "stages", ["competition_id"], :name => "stages_competition_id"
    add_index "stages", ["competition_id", "title"], :name => "stages_competition_id_key", :unique => true
    add_index "stages", ["slug", "competition_id"], :name => "stages_competition_id_key1", :unique => true
    add_index "stages", ["position", "competition_id"], :name => "stages_competition_id_key2", :unique => true

    create_table "groups", :force => true do |t|
      t.column "stage_id", :integer
      t.column "title", :string, :limit => 64, :null => false
      t.column "slug", :string, :limit => 128, :null => false
      t.column "games_count", :integer, :default => 0
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "groups", ["stage_id"], :name => "groups_stage_id"
    add_index "groups", ["stage_id", "title"], :name => "groups_stage_id_key", :unique => true
    add_index "groups", ["stage_id", "slug"], :name => "groups_stage_id_key1", :unique => true

    create_table "groups_teams", :id => false, :force => true do |t|
      t.column "group_id", :integer, :null => false
      t.column "team_id", :integer, :null => false
    end
    add_index "groups_teams", ["group_id"], :name => "groups_teams_group_id"
    add_index "groups_teams", ["team_id"], :name => "groups_teams_team_id"

    create_table "modifications", :force => true do |t|
      t.column "group_id", :integer
      t.column "team_id", :integer
      t.column "value", :integer, :null => false
      t.column "notes", :string, :limit => 512, :null => false
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "modifications", ["group_id"], :name => "modifications_group_id"
    add_index "modifications", ["team_id"], :name => "modifications_team_id"
  
    create_table "games", :force => true do |t|
      t.column "group_id", :integer
      t.column "kickoff", :datetime
      t.column "hometeam_id", :integer
      t.column "home_score", :integer
      t.column "home_notes", :string, :limit => 64
      t.column "home_points", :integer
      t.column "awayteam_id", :integer
      t.column "away_score", :integer
      t.column "away_notes", :string, :limit => 64
      t.column "away_points", :integer
      t.column "summary", :text
      t.column "played", :boolean, :default => false, :null => false
      t.column "created_on", :datetime
      t.column "updated_on", :datetime
    end
    add_index "games", ["group_id"], :name => "games_group_id"
    add_index "games", ["awayteam_id"], :name => "games_awayteam_id"
    add_index "games", ["hometeam_id"], :name => "games_hometeam_id"
    
    create_table :contact_responses do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :message, :text
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :resolved, :boolean, :default => false
    end
    
    create_table :invites do |t|
      t.column :code, :string, :length => 16, :null => false, :unique => true
      t.column :recipient, :string
      t.column :used, :boolean, :default => false
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
  end

  def self.down
    drop_table :invites
    drop_table :contact_responses
    drop_table :games
    drop_table :modifications
    drop_table :groups_teams
    drop_table :groups
    drop_table :stages
    drop_table :competitions
    drop_table :seasons
    drop_table :teams
    drop_table :pages
    drop_table :comments
    drop_table :notices
    drop_table :users
    drop_table :organisations
    drop_table :sports
  end
end
