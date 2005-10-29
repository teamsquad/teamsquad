drop view standings;
drop table games cascade;
drop table modifications cascade;
drop table groups_teams cascade;
drop table groups cascade;
drop table stages cascade;
drop table competitions cascade;
drop table seasons cascade;
drop table teams cascade;
drop table pages cascade;
drop table comments cascade;
drop table notices cascade;
drop table users cascade;
drop table organisations cascade;
drop table sports cascade;

START TRANSACTION;

create table sports (
	id serial primary key,
	title varchar(64) unique not null,
	uses_scores boolean default true,
	uses_manual_points boolean default false
);

create table organisations (
	id serial primary key,
	sport_id int references sports(id) on delete cascade,
	title varchar(64) unique not null,
	nickname varchar(32) unique not null,
	summary varchar(512) not null,
	seasons_count int default 0,
	created_on timestamp default now()
);

create index organisations_sport_id on organisations (sport_id);

create table users (
	id serial primary key,
	organisation_id int references organisations(id) on delete cascade,
	email varchar(256) unique not null,
	password varchar(256) not null,
	name varchar(128) not null
);

create index users_organisation_id on users (organisation_id);

create table notices (
	id serial primary key,
	organisation_id int references organisations(id) on delete cascade,
	user_id int references users(id) on delete cascade,
	heading varchar(128) not null,
	content text not null,
	picture varchar(256),
	comments_count int default 0,
	created_on timestamp default now(),
	UNIQUE (organisation_id, heading)
);

create index notices_organisation_id on notices (organisation_id);

create table comments (
	id serial primary key,
	notice_id int references notices(id) on delete cascade,
	name varchar(128),
	content text not null,
	ip_address varchar(16),
	created_on timestamp default now()
);

create index comments_notice_id on comments (notice_id);

create table pages (
	id serial primary key,
	organisation_id int references organisations(id) on delete cascade,
	title varchar(128) not null,
	content text not null,
	picture varchar(256),
	rank int not null,
	created_on timestamp default now(),
	updated_on timestamp default now(),
	UNIQUE (organisation_id, title)
);

create index pages_organisation_id on pages (organisation_id);

create table teams (
	id serial primary key,
	organisation_id int references organisations(id) on delete cascade,
	title varchar(64) not null,
	created_on timestamp default now(),
	UNIQUE (organisation_id, title)
);

create index teams_organisation_id on teams (organisation_id);

create table seasons (
	id serial primary key,
	organisation_id int references organisations(id) on delete cascade,
	title varchar(64) not null,
	competitions_count int default 0,
	created_on timestamp default now(),
	UNIQUE (organisation_id, title)
);

create index seasons_organisation_id on seasons (organisation_id);

create table competitions (
	id serial primary key,
	season_id int references seasons(id) on delete cascade,
	title varchar(64) not null,
	summary text,
	rank int not null,
	stages_count int default 0,
	created_on timestamp default now(),
	UNIQUE (season_id, title),
	UNIQUE (season_id, rank)
);

create index competitions_season_id on competitions (season_id);

create table stages (
	id serial primary key,
	competition_id int  references competitions(id) on delete cascade,
	title varchar(64) not null,
	rank int not null,
	groups_count int default 0,
	automatic_promotion_places int,
	conditional_promotion_places int,
	automatic_relegation_places int,
	conditional_relegation_places int,
	is_knockout boolean not null,
	points_for_win int default 3,
	points_for_draw int default 1,
	points_for_loss int default 0,
	created_on timestamp default now(),
	UNIQUE (competition_id, title),
	UNIQUE (competition_id, rank)
);

create index stages_competition_id on stages (competition_id);

create table groups (
	id serial primary key,
	stage_id int  references stages(id) on delete cascade,
	title varchar(64) not null,
	created_on timestamp default now(),
	UNIQUE (stage_id, title)
);

create index groups_stage_id on groups (stage_id);

create table groups_teams (
	group_id int references groups(id) on delete cascade,
	team_id int references teams(id) on delete cascade,
	CONSTRAINT groups_teams_pkey PRIMARY KEY(group_id, team_id)
);

create table modifications (
	id serial primary key,
	group_id int references groups(id) on delete cascade,
	team_id int references teams(id) on delete cascade,
	value int not null,
	notes varchar(512) not null
);

create index modifications_group_id on modifications (group_id);
create index modifications_team_id on modifications (team_id);
	
create table games (
	id serial primary key,
	group_id int references groups(id) on delete cascade,
	kickoff timestamp,
	hometeam_id int references teams(id) on delete cascade,
	home_score int,
	home_notes varchar(64),
	home_points int,
	awayteam_id int references teams(id)  on delete cascade,
	away_score int,
	away_notes varchar(64),
	away_points int,
	summary text,
	played boolean default false not null,
	created_on timestamp default now(),
	updated_on timestamp
);

create index games_hometeam_id on games (hometeam_id);
create index games_awayteam_id on games (awayteam_id);

create view standings as
SELECT
	gt.group_id,
	t.id,
	t.title,
	sum(CASE WHEN g.hometeam_id=t.id THEN 1 ELSE 0 END) AS homeplayed, 
	coalesce(sum(CASE WHEN g.hometeam_id=t.id AND g.home_score>g.away_score THEN 1 END),0) AS homewon,
	coalesce(sum(CASE WHEN g.hometeam_id=t.id AND g.home_score=g.away_score THEN 1 END),0) AS homedrawn,
	coalesce(sum(CASE WHEN g.hometeam_id=t.id AND g.home_score<g.away_score THEN 1 END),0) AS homelost,
	coalesce(sum(CASE WHEN g.hometeam_id=t.id THEN g.home_score ELSE 0 END),0) AS homefor,
	coalesce(sum(CASE WHEN g.hometeam_id=t.id THEN g.away_score ELSE 0 END),0) AS homeagainst,
	sum(CASE WHEN g.awayteam_id=t.id THEN 1 ELSE 0 END) AS awayplayed,
	coalesce(sum(CASE WHEN g.awayteam_id=t.id AND g.home_score>g.away_score THEN 1 END),0) AS awaylost,
	coalesce(sum(CASE WHEN g.awayteam_id=t.id AND g.home_score=g.away_score THEN 1 END),0) AS awaydrawn,
	coalesce(sum(CASE WHEN g.awayteam_id=t.id AND g.home_score<g.away_score THEN 1 END),0) AS awaywon,
	coalesce(sum(CASE WHEN g.awayteam_id=t.id THEN g.home_score ELSE 0 END),0) AS awayagainst,
	coalesce(sum(CASE WHEN g.awayteam_id=t.id THEN g.away_score ELSE 0 END),0) AS awayfor,
	coalesce(sum(CASE WHEN g.hometeam_id=t.id THEN home_points ELSE away_points END),0) AS totalpoints
FROM
	groups_teams gt
LEFT JOIN
	teams t ON t.id=gt.team_id
LEFT JOIN
	games g ON g.group_id=gt.group_id AND t.id in (g.hometeam_id, g.awayteam_id) AND g.played='true'
GROUP BY
	gt.group_id, 	
	t.id,
	t.title;

END;