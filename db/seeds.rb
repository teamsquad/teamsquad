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

puts "Creating seasons"
season = test_organisation.seasons.build(
  :title => '2012'
)
season.save

puts "Creating user"
user = test_organisation.users.build(
  :email => 'test@teamsquad.com',
  :password => 'password',
  :name => 'Terry Tester'
)
user.save

content = "h3. Mea id tempor laoreet suscipit.

Tale dicit iracundia eu vel. Congue percipit in vis. His impetus intellegebat at, ut pri sumo aliquid deserunt. An qui viris senserit partiendo, eu pro mollis viderer, veri maiestatis cotidieque pri ut. Velit euripidis no vel.

h3. Timeam praesent consectetuer qui et.

Nam omittam contentiones ut. Ius ad harum incorrupte, reque graece molestie no eos. Id semper aliquip facilisis mea, doming erroribus ei vel, iudico vocibus dissentiunt ne quo. Cu delenit expetenda qui. Sea an vero putant, aperiri sensibus antiopam ne vel, ad est delectus volutpat complectitur.

Ad eos habemus delectus sensibus. Mel diam delenit et, eum ex iisque splendide. Has prima facilisis at. Nec ut omnis noster vituperatoribus, malorum forensibus contentiones ei est."

puts "Creating pages"

test_organisation.pages.build(
  :title => "Rules and regulations",
  :position => 1,
  :content => content
).save

test_organisation.pages.build(
  :title => "Child safety policy",
  :position => 2,
  :content => content
).save

test_organisation.pages.build(
  :title => "Disciplinary procedures",
  :position => 3,
  :content => content
).save

test_organisation.pages.build(
  :title => "League committee",
  :position => 4,
  :content => content
).save

test_organisation.pages.build(
  :title => "Sports hall locations",
  :position => 5,
  :content => content
).save

test_organisation.pages.build(
  :title => "Press office",
  :position => 6,
  :content => content
).save

test_organisation.pages.build(
  :title => "Records",
  :position => 7,
  :content => content
).save

puts "Creating notices"

test_organisation.notices.build(
  :user_id => user.id,
  :heading => 'Welcome to the test organisation!',
  :created_on => 20.weeks.ago,
  :updated_on => 20.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Don't forget to pay your league subs!",
  :created_on => 19.weeks.ago,
  :updated_on => 19.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Please leave all facilities clean after matches",
  :created_on => 18.weeks.ago,
  :updated_on => 18.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Get your tickets for the annual dinner and awards night",
  :created_on => 17.weeks.ago,
  :updated_on => 17.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Please give referees the respect they deserve",
  :created_on => 16.weeks.ago,
  :updated_on => 16.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Rules have been updated",
  :created_on => 15.weeks.ago,
  :updated_on => 15.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Don't forget to vote for player of the year",
  :created_on => 14.weeks.ago,
  :updated_on => 14.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Main sports hall closed for painting work",
  :created_on => 13.weeks.ago,
  :updated_on => 13.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Fines increased for abusive behaviour",
  :created_on => 12.weeks.ago,
  :updated_on => 12.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Charity matches a huge success",
  :created_on => 11.weeks.ago,
  :updated_on => 11.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Fixtures changes are now live",
  :created_on => 10.weeks.ago,
  :updated_on => 10.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Don't forget all players must wear shin pads",
  :created_on => 9.weeks.ago,
  :updated_on => 9.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Sports hall car park out of action for a week",
  :created_on => 8.weeks.ago,
  :updated_on => 8.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "New player registration forms ready to roll",
  :created_on => 7.weeks.ago,
  :updated_on => 7.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "New league treasurer needed",
  :created_on => 6.weeks.ago,
  :updated_on => 6.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "New teams wanted",
  :created_on => 5.weeks.ago,
  :updated_on => 5.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Team sheet format change coming - prepare now",
  :created_on => 4.weeks.ago,
  :updated_on => 4.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "New balls have been ordered",
  :created_on => 3.weeks.ago,
  :updated_on => 3.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "New league sponser signs up",
  :created_on => 2.weeks.ago,
  :updated_on => 2.weeks.ago,
  :content => content
).save

test_organisation.notices.build(
  :user_id => user.id,
  :heading => "Anybody intereted in playing friendlies?",
  :created_on => 1.week.ago,
  :updated_on => 1.week.ago,
  :content => content
).save

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

puts "Creating super cup groups"
super_cup_group_a = super_cup_group_stage.groups.build( :title => 'Group A', :slug => 'group-a' )
super_cup_group_b = super_cup_group_stage.groups.build( :title => 'Group B', :slug => 'group-b' )
super_cup_group_c = super_cup_group_stage.groups.build( :title => 'Group C', :slug => 'group-c' )
super_cup_group_d = super_cup_group_stage.groups.build( :title => 'Group D', :slug => 'group-d' )

super_cup_quarter_final_match_1 = super_cup_quarterfinals.groups.build( :title => 'Match 1', :slug => 'match-1' )
super_cup_quarter_final_match_2 = super_cup_quarterfinals.groups.build( :title => 'Match 2', :slug => 'match-2' )
super_cup_quarter_final_match_3 = super_cup_quarterfinals.groups.build( :title => 'Match 3', :slug => 'match-3' )
super_cup_quarter_final_match_4 = super_cup_quarterfinals.groups.build( :title => 'Match 4', :slug => 'match-4' )

super_cup_semi_final_match_1 = super_cup_semi_finals.groups.build( :title => 'Semi final 1', :slug => 'match-1' )
super_cup_semi_final_match_2 = super_cup_semi_finals.groups.build( :title => 'Semi final 2', :slug => 'match-2' )

super_cup_final_match = super_cup_final.groups.build( :title => 'The final', :slug => 'the-final' )

puts "Putting teams in to super cup groups"
super_cup_group_a.teams << team_a
super_cup_group_a.teams << team_b
super_cup_group_a.teams << team_c
super_cup_group_a.teams << team_d

super_cup_group_b.teams << team_e
super_cup_group_b.teams << team_f
super_cup_group_b.teams << team_g
super_cup_group_b.teams << team_h

super_cup_group_c.teams << team_i
super_cup_group_c.teams << team_j
super_cup_group_c.teams << team_k
super_cup_group_c.teams << team_l

super_cup_group_d.teams << team_m
super_cup_group_d.teams << team_n
super_cup_group_d.teams << team_o
super_cup_group_d.teams << team_p

super_cup_group_a.save
super_cup_group_b.save
super_cup_group_c.save
super_cup_group_d.save

super_cup_quarter_final_match_1.save
super_cup_quarter_final_match_2.save
super_cup_quarter_final_match_3.save
super_cup_quarter_final_match_4.save

super_cup_semi_final_match_1.save
super_cup_semi_final_match_2.save

super_cup_final_match.save

puts "Creating super cup games"
super_cup_group_a.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_a.id, :awayteam_id => team_b.id).save
super_cup_group_a.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_c.id, :awayteam_id => team_d.id).save
super_cup_group_a.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_b.id, :awayteam_id => team_c.id).save
super_cup_group_a.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_d.id, :awayteam_id => team_a.id).save
super_cup_group_a.games.build( :kickoff => '2013-01-24 15:00:00', :hometeam_id => team_a.id, :awayteam_id => team_c.id).save
super_cup_group_a.games.build( :kickoff => '2013-01-24 15:30:00', :hometeam_id => team_b.id, :awayteam_id => team_d.id).save
super_cup_group_a.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_b.id, :awayteam_id => team_a.id).save
super_cup_group_a.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_d.id, :awayteam_id => team_c.id).save
super_cup_group_a.games.build( :kickoff => '2013-02-17 15:30:00', :hometeam_id => team_c.id, :awayteam_id => team_b.id).save
super_cup_group_a.games.build( :kickoff => '2013-02-17 15:00:00', :hometeam_id => team_a.id, :awayteam_id => team_d.id).save
super_cup_group_a.games.build( :kickoff => '2013-02-24 15:00:00', :hometeam_id => team_c.id, :awayteam_id => team_a.id).save
super_cup_group_a.games.build( :kickoff => '2013-02-24 15:30:00', :hometeam_id => team_d.id, :awayteam_id => team_b.id).save

super_cup_group_b.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_e.id, :awayteam_id => team_f.id).save
super_cup_group_b.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_g.id, :awayteam_id => team_h.id).save
super_cup_group_b.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_f.id, :awayteam_id => team_g.id).save
super_cup_group_b.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_h.id, :awayteam_id => team_e.id).save
super_cup_group_b.games.build( :kickoff => '2013-01-24 15:00:00', :hometeam_id => team_e.id, :awayteam_id => team_g.id).save
super_cup_group_b.games.build( :kickoff => '2013-01-24 15:30:00', :hometeam_id => team_f.id, :awayteam_id => team_h.id).save
super_cup_group_b.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_f.id, :awayteam_id => team_e.id).save
super_cup_group_b.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_h.id, :awayteam_id => team_g.id).save
super_cup_group_b.games.build( :kickoff => '2013-02-17 15:30:00', :hometeam_id => team_g.id, :awayteam_id => team_f.id).save
super_cup_group_b.games.build( :kickoff => '2013-02-17 15:00:00', :hometeam_id => team_e.id, :awayteam_id => team_h.id).save
super_cup_group_b.games.build( :kickoff => '2013-02-24 15:00:00', :hometeam_id => team_g.id, :awayteam_id => team_e.id).save
super_cup_group_b.games.build( :kickoff => '2013-02-24 15:30:00', :hometeam_id => team_h.id, :awayteam_id => team_f.id).save

super_cup_group_c.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_i.id, :awayteam_id => team_j.id).save
super_cup_group_c.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_k.id, :awayteam_id => team_l.id).save
super_cup_group_c.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_j.id, :awayteam_id => team_k.id).save
super_cup_group_c.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_l.id, :awayteam_id => team_i.id).save
super_cup_group_c.games.build( :kickoff => '2013-01-24 15:00:00', :hometeam_id => team_i.id, :awayteam_id => team_k.id).save
super_cup_group_c.games.build( :kickoff => '2013-01-24 15:30:00', :hometeam_id => team_j.id, :awayteam_id => team_l.id).save
super_cup_group_c.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_j.id, :awayteam_id => team_i.id).save
super_cup_group_c.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_l.id, :awayteam_id => team_k.id).save
super_cup_group_c.games.build( :kickoff => '2013-02-17 15:30:00', :hometeam_id => team_k.id, :awayteam_id => team_j.id).save
super_cup_group_c.games.build( :kickoff => '2013-02-17 15:00:00', :hometeam_id => team_i.id, :awayteam_id => team_l.id).save
super_cup_group_c.games.build( :kickoff => '2013-02-24 15:00:00', :hometeam_id => team_k.id, :awayteam_id => team_i.id).save
super_cup_group_c.games.build( :kickoff => '2013-02-24 15:30:00', :hometeam_id => team_l.id, :awayteam_id => team_j.id).save

super_cup_group_d.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_m.id, :awayteam_id => team_n.id).save
super_cup_group_d.games.build( :kickoff => '2013-01-10 15:00:00', :hometeam_id => team_o.id, :awayteam_id => team_p.id).save
super_cup_group_d.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_n.id, :awayteam_id => team_o.id).save
super_cup_group_d.games.build( :kickoff => '2013-01-17 15:00:00', :hometeam_id => team_p.id, :awayteam_id => team_m.id).save
super_cup_group_d.games.build( :kickoff => '2013-01-24 15:00:00', :hometeam_id => team_m.id, :awayteam_id => team_o.id).save
super_cup_group_d.games.build( :kickoff => '2013-01-24 15:30:00', :hometeam_id => team_n.id, :awayteam_id => team_p.id).save
super_cup_group_d.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_n.id, :awayteam_id => team_m.id).save
super_cup_group_d.games.build( :kickoff => '2013-02-10 15:00:00', :hometeam_id => team_p.id, :awayteam_id => team_o.id).save
super_cup_group_d.games.build( :kickoff => '2013-02-17 15:30:00', :hometeam_id => team_o.id, :awayteam_id => team_n.id).save
super_cup_group_d.games.build( :kickoff => '2013-02-17 15:00:00', :hometeam_id => team_m.id, :awayteam_id => team_p.id).save
super_cup_group_d.games.build( :kickoff => '2013-02-24 15:00:00', :hometeam_id => team_o.id, :awayteam_id => team_m.id).save
super_cup_group_d.games.build( :kickoff => '2013-02-24 15:30:00', :hometeam_id => team_p.id, :awayteam_id => team_n.id).save

super_cup_quarter_final_match_1.games.build( :kickoff => '2013-03-02 15:00:00', :hometeam_id => nil, :awayteam_id => nil).save
super_cup_quarter_final_match_2.games.build( :kickoff => '2013-03-02 15:00:00', :hometeam_id => nil, :awayteam_id => nil).save
super_cup_quarter_final_match_3.games.build( :kickoff => '2013-03-02 15:00:00', :hometeam_id => nil, :awayteam_id => nil).save
super_cup_quarter_final_match_4.games.build( :kickoff => '2013-03-02 15:00:00', :hometeam_id => nil, :awayteam_id => nil).save

super_cup_semi_final_match_1.games.build( :kickoff => '2013-03-09 15:00:00', :hometeam_id => nil, :awayteam_id => nil).save
super_cup_semi_final_match_2.games.build( :kickoff => '2013-03-09 15:00:00', :hometeam_id => nil, :awayteam_id => nil).save

super_cup_final_match.games.build( :kickoff => '2013-03-20 16:00:00', :hometeam_id => nil, :awayteam_id => nil).save
