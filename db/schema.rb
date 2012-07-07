# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "comments", :force => true do |t|
    t.integer  "notice_id"
    t.string   "name",       :limit => 128
    t.text     "content",                   :null => false
    t.string   "ip_address", :limit => 16
    t.string   "user_agent", :limit => 128
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "comments", ["notice_id"], :name => "comments_notice_id"

  create_table "competitions", :force => true do |t|
    t.integer  "season_id"
    t.string   "title",        :limit => 64,                 :null => false
    t.string   "slug",         :limit => 128,                :null => false
    t.text     "summary"
    t.integer  "position",                    :default => 1
    t.integer  "stages_count",                :default => 0
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "label",        :limit => 32
  end

  add_index "competitions", ["position", "season_id"], :name => "competitions_season_id_key2", :unique => true
  add_index "competitions", ["season_id", "title"], :name => "competitions_season_id_key", :unique => true
  add_index "competitions", ["season_id"], :name => "competitions_season_id"
  add_index "competitions", ["slug", "season_id"], :name => "competitions_season_id_key1", :unique => true

  create_table "contact_responses", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "resolved",   :default => false
  end

  create_table "games", :force => true do |t|
    t.integer  "group_id"
    t.datetime "kickoff"
    t.integer  "hometeam_id"
    t.integer  "home_score"
    t.string   "home_notes",  :limit => 64
    t.integer  "home_points"
    t.integer  "awayteam_id"
    t.integer  "away_score"
    t.string   "away_notes",  :limit => 64
    t.integer  "away_points"
    t.text     "summary"
    t.boolean  "played",                    :default => false, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "games", ["awayteam_id"], :name => "games_awayteam_id"
  add_index "games", ["group_id"], :name => "games_group_id"
  add_index "games", ["hometeam_id"], :name => "games_hometeam_id"

  create_table "groups", :force => true do |t|
    t.integer  "stage_id"
    t.string   "title",       :limit => 64,                 :null => false
    t.string   "slug",        :limit => 128,                :null => false
    t.integer  "games_count",                :default => 0
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "groups", ["stage_id", "slug"], :name => "groups_stage_id_key1", :unique => true
  add_index "groups", ["stage_id", "title"], :name => "groups_stage_id_key", :unique => true
  add_index "groups", ["stage_id"], :name => "groups_stage_id"

  create_table "groups_teams", :id => false, :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "team_id",  :null => false
  end

  add_index "groups_teams", ["group_id"], :name => "groups_teams_group_id"
  add_index "groups_teams", ["team_id"], :name => "groups_teams_team_id"

  create_table "invites", :force => true do |t|
    t.string   "code",                          :null => false
    t.string   "recipient"
    t.boolean  "used",       :default => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "modifications", :force => true do |t|
    t.integer  "group_id"
    t.integer  "team_id"
    t.integer  "value",                     :null => false
    t.string   "notes",      :limit => 512, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "modifications", ["group_id"], :name => "modifications_group_id"
  add_index "modifications", ["team_id"], :name => "modifications_team_id"

  create_table "notices", :force => true do |t|
    t.integer  "organisation_id"
    t.integer  "user_id"
    t.string   "heading",         :limit => 128,                :null => false
    t.string   "slug",            :limit => 128,                :null => false
    t.text     "content",                                       :null => false
    t.string   "picture",         :limit => 256
    t.integer  "comments_count",                 :default => 0
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "notices", ["organisation_id", "heading"], :name => "notices_organisation_id_key", :unique => true
  add_index "notices", ["organisation_id", "slug"], :name => "notices_organisation_id_key1", :unique => true
  add_index "notices", ["organisation_id"], :name => "notices_organisation_id"

  create_table "organisations", :force => true do |t|
    t.integer  "sport_id"
    t.string   "title",         :limit => 128,                :null => false
    t.string   "nickname",      :limit => 32,                 :null => false
    t.string   "summary",       :limit => 512,                :null => false
    t.integer  "seasons_count",                :default => 0
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "logo",          :limit => 200
  end

  add_index "organisations", ["nickname"], :name => "organisations_nickname_key", :unique => true
  add_index "organisations", ["sport_id"], :name => "organisations_sport_id"
  add_index "organisations", ["title"], :name => "organisations_title_key", :unique => true

  create_table "pages", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "title",           :limit => 128, :null => false
    t.string   "slug",            :limit => 128, :null => false
    t.text     "content",                        :null => false
    t.string   "picture",         :limit => 256
    t.integer  "position",                       :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "label",           :limit => 32
  end

  add_index "pages", ["organisation_id", "slug"], :name => "pages_organisation_id_key1", :unique => true
  add_index "pages", ["organisation_id", "title"], :name => "pages_organisation_id_key", :unique => true
  add_index "pages", ["organisation_id"], :name => "pages_organisation_id"

  create_table "seasons", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "title",              :limit => 64,                     :null => false
    t.string   "slug",               :limit => 128,                    :null => false
    t.integer  "competitions_count",                :default => 0
    t.boolean  "is_complete",                       :default => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "seasons", ["organisation_id", "slug"], :name => "seasons_organisation_id_key1", :unique => true
  add_index "seasons", ["organisation_id", "title"], :name => "seasons_organisation_id_key", :unique => true
  add_index "seasons", ["organisation_id"], :name => "seasons_organisation_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

  create_table "sports", :force => true do |t|
    t.string  "title",              :limit => 64,                    :null => false
    t.boolean "uses_scores",                      :default => true
    t.boolean "uses_manual_points",               :default => false
    t.boolean "uses_teams",                       :default => true
    t.boolean "uses_kits",                        :default => true
  end

  add_index "sports", ["title"], :name => "sports_title_key", :unique => true

  create_table "stages", :force => true do |t|
    t.integer  "competition_id"
    t.string   "title",                         :limit => 64,                     :null => false
    t.string   "slug",                          :limit => 128,                    :null => false
    t.integer  "position",                                     :default => 1
    t.integer  "groups_count",                                 :default => 0
    t.integer  "automatic_promotion_places"
    t.integer  "conditional_promotion_places"
    t.integer  "automatic_relegation_places"
    t.integer  "conditional_relegation_places"
    t.boolean  "is_knockout",                                  :default => false
    t.boolean  "is_complete",                                  :default => false
    t.integer  "points_for_win",                               :default => 3
    t.integer  "points_for_draw",                              :default => 1
    t.integer  "points_for_loss",                              :default => 0
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "stages", ["competition_id", "title"], :name => "stages_competition_id_key", :unique => true
  add_index "stages", ["competition_id"], :name => "stages_competition_id"
  add_index "stages", ["position", "competition_id"], :name => "stages_competition_id_key2", :unique => true
  add_index "stages", ["slug", "competition_id"], :name => "stages_competition_id_key1", :unique => true

  create_table "teams", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "title",           :limit => 64,  :null => false
    t.string   "slug",            :limit => 128, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "teams", ["organisation_id", "slug"], :name => "teams_organisation_id_key1", :unique => true
  add_index "teams", ["organisation_id", "title"], :name => "teams_organisation_id_key", :unique => true
  add_index "teams", ["organisation_id"], :name => "teams_organisation_id"

  create_table "users", :force => true do |t|
    t.integer  "organisation_id"
    t.string   "email",           :limit => 256, :null => false
    t.string   "password",        :limit => 256, :null => false
    t.string   "name",            :limit => 128, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "users", ["email"], :name => "users_email_key", :unique => true
  add_index "users", ["organisation_id"], :name => "users_organisation_id"

end
