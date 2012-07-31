# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

puts "Creating sports"
football = Sport.create :title => "Football"
Sport.create :title => "Cricket", :uses_scores => false, :uses_manual_points => true
Sport.create :title => "Tennis", :uses_scores => true
Sport.create :title => "Table tennis", :uses_scores => true, :uses_teams => false
Sport.create :title => "Badminton", :uses_scores => true, :uses_teams => false
Sport.create :title => "Hockey", :uses_scores => true
Sport.create :title => "Rugby", :uses_scores => true, :uses_manual_points => true
Sport.create :title => "Chess", :uses_scores => true, :uses_teams => false
Sport.create :title => "Bowls", :uses_scores => true

puts "Creating invites"
20.times do 
  temp_code = rand(99999999999) + 1000000000000
  Invite.create(:code => temp_code.to_s)
end

puts "Creating organisations"
test_organisation = Organisation.new(
  :title => "Test Organisation",
  :nickname => "test",
  :summary => "A simple little organisation for testing with.",
  :theme => 'classic',
  :sport_id => football.id
)
test_organisation.save

olympics_organisation = Organisation.new(
  :title => "Olympics",
  :nickname => "olympics",
  :summary => "Olympic football to use as a test.",
  :theme => 'classic',
  :sport_id => football.id
)
olympics_organisation.save

puts "Creating seasons"
season = test_organisation.seasons.build(
  :title => '2012'
)
season.save

olympic_season = olympics_organisation.seasons.build(
  :title => 'London 2012'
)
olympic_season.save

puts "Creating user"
user = test_organisation.users.build(
  :email => 'test@teamsquad.com',
  :password => 'password',
  :name => 'Terry Tester'
)
user.save

puts "Creating teams"
team_a = test_organisation.teams.build( :title => 'Alpha Athletic', :slug => 'alpha-athletic' )
team_b = test_organisation.teams.build( :title => 'Bravo Bombers', :slug => 'bravo-bombers' )
team_c = test_organisation.teams.build( :title => 'Charlie City', :slug => 'charlie-city' )
team_d = test_organisation.teams.build( :title => 'Dynamo Deltas', :slug => 'dynamo-deltas' )
team_e = test_organisation.teams.build( :title => 'Echo Evergreens', :slug => 'echo-evergreens' )
team_f = test_organisation.teams.build( :title => 'FC Foxtrot', :slug => 'fc-foxtrot' )
team_g = test_organisation.teams.build( :title => 'Getahead Golfers', :slug => 'getahead-golfers' )
team_h = test_organisation.teams.build( :title => 'Hotel Hotspur', :slug => 'hotel-hotspur' )
team_i = test_organisation.teams.build( :title => 'Indigo Ingrates', :slug => 'indigo-ingrates' )
team_j = test_organisation.teams.build( :title => 'Juliet Jumpers', :slug => 'juliet-jumpers' )
team_k = test_organisation.teams.build( :title => 'Kilo Killers', :slug => 'kilo-killers' )
team_l = test_organisation.teams.build( :title => 'Lima Lollopers', :slug => 'lima-lollopers' )
team_m = test_organisation.teams.build( :title => 'Mike Mania', :slug => 'mike-mania' )
team_n = test_organisation.teams.build( :title => 'November Normals', :slug => 'november-normals' )
team_o = test_organisation.teams.build( :title => 'Oscar Overachievers', :slug => 'oscar-overachievers' )
team_p = test_organisation.teams.build( :title => 'Papa Pathetics', :slug => 'papa-pathetics' )
team_q = test_organisation.teams.build( :title => 'Quebec Quagmires', :slug => 'quebec-quagmires' )
team_r = test_organisation.teams.build( :title => 'Romeo Rovers', :slug => 'romeo-rovers' )
team_s = test_organisation.teams.build( :title => 'Sierra Shooters', :slug => 'sierra-shooters' )
team_t = test_organisation.teams.build( :title => 'Tango Town', :slug => 'tango-town' )
team_u = test_organisation.teams.build( :title => 'Uniform University', :slug => 'uniform University' )
team_v = test_organisation.teams.build( :title => 'Victor Vase', :slug => 'victor-vase' )
team_w = test_organisation.teams.build( :title => 'Whiskey Wednesday', :slug => 'whiskey-wednesday' )
team_x = test_organisation.teams.build( :title => 'Xray Xenons', :slug => 'xray-xenons' )
team_y = test_organisation.teams.build( :title => 'Yankee Doodle Dandies', :slug => 'yankee-doodle-dandies' )
team_z = test_organisation.teams.build( :title => 'Zulu Zippers', :slug => 'zulu-zippers' )
team_1 = test_organisation.teams.build( :title => 'One Uppers', :slug => 'one-uppers' )
team_2 = test_organisation.teams.build( :title => 'Two Timers', :slug => 'two-timers' )
team_3 = test_organisation.teams.build( :title => 'Three Ways', :slug => 'three-ways' )
team_4 = test_organisation.teams.build( :title => 'Four Strokes', :slug => 'four-strokes' )
team_5 = test_organisation.teams.build( :title => 'Five Star', :slug => 'five-star' )
team_6 = test_organisation.teams.build( :title => 'Six Toes', :slug => 'six-toes' )

team_a.save
team_b.save
team_c.save
team_d.save
team_e.save
team_f.save
team_g.save
team_h.save
team_i.save
team_j.save
team_k.save
team_l.save
team_m.save
team_n.save
team_o.save
team_p.save
team_q.save
team_r.save
team_s.save
team_t.save
team_u.save
team_v.save
team_w.save
team_x.save
team_y.save
team_z.save
team_1.save
team_2.save
team_3.save
team_4.save
team_5.save
team_6.save

puts "Creating a notice"
test_organisation.notices.build(
  :user_id => user.id,
  :heading => 'Welcome to the test organisation!',
  :slug => 'welcome',
  :content => 'Have a look around and check everything is tickety boo.'
).save

puts "Creating competitions"
division_one = season.competitions.build(
  :title => 'Division One',
  :slug => 'division-one',
  :summary => 'The creme-de-la-creme.',
  :position => 1
)

division_two = season.competitions.build(
  :title => 'Division Two',
  :slug => 'division-two',
  :summary => 'The try hards.',
  :position => 2
)

league_cup = season.competitions.build(
  :title => 'League Cup',
  :slug => 'league-cup',
  :summary => 'Open to everyone.',
  :position => 3
)

super_cup = season.competitions.build(
  :title => 'Super Cup',
  :slug => 'super-cup',
  :summary => 'Only the best can compete.',
  :position => 4
)

division_one.save
division_two.save
league_cup.save
super_cup.save

puts "Creating stages"
division_one_stage = division_one.stages.build(
  :title => 'League table',
  :slug => 'league-table',
  :position => 1,
  :automatic_promotion_places => 0,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 2,
  :conditional_relegation_places => 0,
  :is_knockout => false
)

division_two_stage = division_two.stages.build(
  :title => 'League table',
  :slug => 'league-table',
  :position => 1,
  :automatic_promotion_places => 0,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 2,
  :conditional_relegation_places => 0,
  :is_knockout => false
)

# 32 teams
league_cup_round_one = league_cup.stages.build(
  :title => 'Round One',
  :slug => 'round-one',
  :position => 1,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

# 16 teams
league_cup_round_two = league_cup.stages.build(
  :title => 'Round Two',
  :slug => 'round-two',
  :position => 2,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

# 8 teams
league_cup_round_three = league_cup.stages.build(
  :title => 'Quarter Finals',
  :slug => 'quarter-finals',
  :position => 3,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

# 4 teams
league_cup_round_four = league_cup.stages.build(
  :title => 'Semi Finals',
  :slug => 'semi-finals',
  :position => 4,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

# 2 teams
league_cup_round_five = league_cup.stages.build(
  :title => 'Final',
  :slug => 'final',
  :position => 5,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

# Group stage (16 teams in 4 groups of 4)
super_cup_group_stage = super_cup.stages.build(
  :title => 'Group stages',
  :slug => 'group-stages',
  :position => 1,
  :automatic_promotion_places => 2,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => false
)

# 8 teams
super_cup_quarterfinals = super_cup.stages.build(
  :title => 'Quarter Finals',
  :slug => 'quarter-finals',
  :position => 2,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

# 4 teams
super_cup_semi_finals = super_cup.stages.build(
  :title => 'Semi Finals',
  :slug => 'semi-finals',
  :position => 3,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

# 2 teams
super_cup_final = super_cup.stages.build(
  :title => 'Final',
  :slug => 'final',
  :position => 4,
  :automatic_promotion_places => 1,
  :conditional_promotion_places => 0,
  :automatic_relegation_places => 0,
  :conditional_relegation_places => 0,
  :is_knockout => true
)

division_one_stage.save
division_two_stage.save

league_cup_round_one.save
league_cup_round_two.save
league_cup_round_three.save
league_cup_round_four.save
league_cup_round_five.save

super_cup_group_stage.save
super_cup_quarterfinals.save
super_cup_semi_finals.save
super_cup_final.save

puts "Creating league groups"
division_one_group = division_one_stage.groups.build( :title => 'Table', :slug => 'table' )
division_two_group = division_two_stage.groups.build( :title => 'Table', :slug => 'table' )

puts "Putting teams in to league groups"
division_one_group.teams << team_a
division_one_group.teams << team_b
division_one_group.teams << team_c
division_one_group.teams << team_d
division_one_group.teams << team_e
division_one_group.teams << team_f
division_one_group.teams << team_g
division_one_group.teams << team_h
division_one_group.teams << team_i
division_one_group.teams << team_j
division_one_group.teams << team_k
division_one_group.teams << team_l
division_one_group.teams << team_m
division_one_group.teams << team_n
division_one_group.teams << team_o
division_one_group.teams << team_p

division_two_group.teams << team_q
division_two_group.teams << team_r
division_two_group.teams << team_s
division_two_group.teams << team_t
division_two_group.teams << team_u
division_two_group.teams << team_v
division_two_group.teams << team_w
division_two_group.teams << team_x
division_two_group.teams << team_y
division_two_group.teams << team_z
division_two_group.teams << team_1
division_two_group.teams << team_2
division_two_group.teams << team_3
division_two_group.teams << team_4
division_two_group.teams << team_5
division_two_group.teams << team_6

division_one_group.save
division_two_group.save

puts "Creating league games"
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_a.id, :home_score => 2, :home_points => 3, :awayteam_id => team_b.id, :away_score => 1, :away_points => 0 ).save
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_c.id, :home_score => 4, :home_points => 3, :awayteam_id => team_d.id, :away_score => 0, :away_points => 0).save
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_e.id, :home_score => 0, :home_points => 0, :awayteam_id => team_f.id, :away_score => 4, :away_points => 3).save
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_g.id, :home_score => 1, :home_points => 0, :awayteam_id => team_h.id, :away_score => 3, :away_points => 3).save
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_i.id, :home_score => 0, :home_points => 1, :awayteam_id => team_j.id, :away_score => 0, :away_points => 1).save
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_k.id, :home_score => 0, :home_points => 0, :awayteam_id => team_l.id, :away_score => 1, :away_points => 3).save
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_m.id, :home_score => 1, :home_points => 0, :awayteam_id => team_n.id, :away_score => 2, :away_points => 3).save
division_one_group.games.build( :kickoff => '2012-07-01 15:00:00', :played => true, :hometeam_id => team_o.id, :home_score => 3, :home_points => 3, :awayteam_id => team_p.id, :away_score => 1, :away_points => 0).save

division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_b.id, :home_score => 0, :home_points => 0, :awayteam_id => team_c.id, :away_score => 1, :away_points => 3).save
division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_d.id, :home_score => 2, :home_points => 1, :awayteam_id => team_e.id, :away_score => 2, :away_points => 1).save
division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_f.id, :home_score => 1, :home_points => 0, :awayteam_id => team_g.id, :away_score => 3, :away_points => 3).save
division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_h.id, :home_score => 4, :home_points => 3, :awayteam_id => team_i.id, :away_score => 0, :away_points => 0).save
division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_j.id, :home_score => 5, :home_points => 3, :awayteam_id => team_k.id, :away_score => 2, :away_points => 0).save
division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_l.id, :home_score => 0, :home_points => 0, :awayteam_id => team_m.id, :away_score => 1, :away_points => 3).save
division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_n.id, :home_score => 3, :home_points => 3, :awayteam_id => team_o.id, :away_score => 0, :away_points => 0).save
division_one_group.games.build( :kickoff => '2012-07-08 15:00:00', :played => true, :hometeam_id => team_p.id, :home_score => 2, :home_points => 3, :awayteam_id => team_a.id, :away_score => 1, :away_points => 0).save

division_one_group.games.build( :kickoff => '2012-07-15 15:00:00', :hometeam_id => team_a.id, :awayteam_id => team_i.id).save
division_one_group.games.build( :kickoff => '2012-07-15 15:00:00', :hometeam_id => team_b.id, :awayteam_id => team_j.id).save
division_one_group.games.build( :kickoff => '2012-07-15 15:00:00', :hometeam_id => team_c.id, :awayteam_id => team_k.id).save
division_one_group.games.build( :kickoff => '2012-07-15 15:00:00', :hometeam_id => team_d.id, :awayteam_id => team_l.id).save
division_one_group.games.build( :kickoff => '2012-07-16 15:00:00', :hometeam_id => team_e.id, :awayteam_id => team_m.id).save
division_one_group.games.build( :kickoff => '2012-07-16 15:00:00', :hometeam_id => team_f.id, :awayteam_id => team_n.id).save
division_one_group.games.build( :kickoff => '2012-07-16 15:00:00', :hometeam_id => team_g.id, :awayteam_id => team_o.id).save
division_one_group.games.build( :kickoff => '2012-07-16 15:00:00', :hometeam_id => team_h.id, :awayteam_id => team_p.id).save

division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_i.id, :awayteam_id => team_g.id).save
division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_j.id, :awayteam_id => team_p.id).save
division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_l.id, :awayteam_id => team_f.id).save
division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_k.id, :awayteam_id => team_b.id).save
division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_c.id, :awayteam_id => team_a.id).save
division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_d.id, :awayteam_id => team_n.id).save
division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_m.id, :awayteam_id => team_o.id).save
division_one_group.games.build( :kickoff => '2012-07-20 15:00:00', :hometeam_id => team_h.id, :awayteam_id => team_e.id).save

puts "Creating league cup groups"
league_cup_round_one_match01 = league_cup_round_one.groups.build( :title => 'Match 01', :slug => 'match01' )
league_cup_round_one_match02 = league_cup_round_one.groups.build( :title => 'Match 02', :slug => 'match02' )
league_cup_round_one_match03 = league_cup_round_one.groups.build( :title => 'Match 03', :slug => 'match03' )
league_cup_round_one_match04 = league_cup_round_one.groups.build( :title => 'Match 04', :slug => 'match04' )
league_cup_round_one_match05 = league_cup_round_one.groups.build( :title => 'Match 05', :slug => 'match05' )
league_cup_round_one_match06 = league_cup_round_one.groups.build( :title => 'Match 06', :slug => 'match06' )
league_cup_round_one_match07 = league_cup_round_one.groups.build( :title => 'Match 07', :slug => 'match07' )
league_cup_round_one_match08 = league_cup_round_one.groups.build( :title => 'Match 08', :slug => 'match08' )
league_cup_round_one_match09 = league_cup_round_one.groups.build( :title => 'Match 09', :slug => 'match09' )
league_cup_round_one_match10 = league_cup_round_one.groups.build( :title => 'Match 10', :slug => 'match10' )
league_cup_round_one_match11 = league_cup_round_one.groups.build( :title => 'Match 11', :slug => 'match11' )
league_cup_round_one_match12 = league_cup_round_one.groups.build( :title => 'Match 12', :slug => 'match12' )
league_cup_round_one_match13 = league_cup_round_one.groups.build( :title => 'Match 13', :slug => 'match13' )
league_cup_round_one_match14 = league_cup_round_one.groups.build( :title => 'Match 14', :slug => 'match14' )
league_cup_round_one_match15 = league_cup_round_one.groups.build( :title => 'Match 15', :slug => 'match15' )
league_cup_round_one_match16 = league_cup_round_one.groups.build( :title => 'Match 16', :slug => 'match16' )

puts "Adding teams to league cup"
league_cup_round_one_match01.teams << team_a
league_cup_round_one_match01.teams << team_b

league_cup_round_one_match02.teams << team_c
league_cup_round_one_match02.teams << team_d

league_cup_round_one_match03.teams << team_e
league_cup_round_one_match03.teams << team_f

league_cup_round_one_match04.teams << team_g
league_cup_round_one_match04.teams << team_h

league_cup_round_one_match05.teams << team_i
league_cup_round_one_match06.teams << team_j

league_cup_round_one_match06.teams << team_k
league_cup_round_one_match06.teams << team_l

league_cup_round_one_match07.teams << team_m
league_cup_round_one_match07.teams << team_n

league_cup_round_one_match08.teams << team_o
league_cup_round_one_match08.teams << team_p

league_cup_round_one_match09.teams << team_q
league_cup_round_one_match09.teams << team_r

league_cup_round_one_match10.teams << team_s
league_cup_round_one_match10.teams << team_t

league_cup_round_one_match11.teams << team_u
league_cup_round_one_match11.teams << team_v

league_cup_round_one_match12.teams << team_w
league_cup_round_one_match12.teams << team_x

league_cup_round_one_match13.teams << team_y
league_cup_round_one_match13.teams << team_z

league_cup_round_one_match14.teams << team_1
league_cup_round_one_match14.teams << team_2

league_cup_round_one_match15.teams << team_3
league_cup_round_one_match15.teams << team_4

league_cup_round_one_match16.teams << team_5
league_cup_round_one_match16.teams << team_6

league_cup_round_one_match01.save
league_cup_round_one_match02.save
league_cup_round_one_match03.save
league_cup_round_one_match04.save
league_cup_round_one_match05.save
league_cup_round_one_match06.save
league_cup_round_one_match07.save
league_cup_round_one_match08.save
league_cup_round_one_match09.save
league_cup_round_one_match10.save
league_cup_round_one_match11.save
league_cup_round_one_match12.save
league_cup_round_one_match13.save
league_cup_round_one_match14.save
league_cup_round_one_match15.save
league_cup_round_one_match16.save

puts "Creating league cup games"
league_cup_round_one_match01.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_a.id, :awayteam_id => team_b.id).save
league_cup_round_one_match02.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_c.id, :awayteam_id => team_d.id).save
league_cup_round_one_match03.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_e.id, :awayteam_id => team_f.id).save
league_cup_round_one_match04.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_g.id, :awayteam_id => team_h.id).save
league_cup_round_one_match05.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_i.id, :awayteam_id => team_j.id).save
league_cup_round_one_match06.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_k.id, :awayteam_id => team_l.id).save
league_cup_round_one_match07.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_m.id, :awayteam_id => team_n.id).save
league_cup_round_one_match08.games.build( :kickoff => '2012-08-01 15:00:00', :hometeam_id => team_o.id, :awayteam_id => team_p.id).save
league_cup_round_one_match09.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_q.id, :awayteam_id => team_r.id).save
league_cup_round_one_match10.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_s.id, :awayteam_id => team_t.id).save
league_cup_round_one_match11.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_u.id, :awayteam_id => team_v.id).save
league_cup_round_one_match12.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_w.id, :awayteam_id => team_x.id).save
league_cup_round_one_match13.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_y.id, :awayteam_id => team_z.id).save
league_cup_round_one_match14.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_1.id, :awayteam_id => team_2.id).save
league_cup_round_one_match15.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_3.id, :awayteam_id => team_4.id).save
league_cup_round_one_match16.games.build( :kickoff => '2012-08-02 15:00:00', :hometeam_id => team_5.id, :awayteam_id => team_6.id).save

