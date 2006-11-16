--
-- PostgreSQL database dump
--

SET client_encoding = 'UNICODE';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: sid
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE teams (
    id serial NOT NULL,
    organisation_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: away_teams; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW away_teams AS
    SELECT teams.id, teams.organisation_id, teams.title, teams.slug, teams.created_on, teams.updated_on FROM teams;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE comments (
    id serial NOT NULL,
    notice_id integer,
    name character varying(128),
    content text NOT NULL,
    ip_address character varying(16),
    user_agent character varying(128),
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: competitions; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE competitions (
    id serial NOT NULL,
    season_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    summary text,
    "position" integer DEFAULT 1,
    stages_count integer DEFAULT 0,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    label character varying(32)
);


--
-- Name: contact_responses; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE contact_responses (
    id serial NOT NULL,
    name character varying(255),
    email character varying(255),
    message text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    resolved boolean DEFAULT false
);


--
-- Name: games; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE games (
    id serial NOT NULL,
    group_id integer,
    kickoff timestamp without time zone,
    hometeam_id integer,
    home_score integer,
    home_notes character varying(64),
    home_points integer,
    awayteam_id integer,
    away_score integer,
    away_notes character varying(64),
    away_points integer,
    summary text,
    played boolean DEFAULT false NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE groups (
    id serial NOT NULL,
    stage_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    games_count integer DEFAULT 0,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: stages; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE stages (
    id serial NOT NULL,
    competition_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    "position" integer DEFAULT 1,
    groups_count integer DEFAULT 0,
    automatic_promotion_places integer,
    conditional_promotion_places integer,
    automatic_relegation_places integer,
    conditional_relegation_places integer,
    is_knockout boolean DEFAULT false,
    is_complete boolean DEFAULT false,
    points_for_win integer DEFAULT 3,
    points_for_draw integer DEFAULT 1,
    points_for_loss integer DEFAULT 0,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: game_days; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW game_days AS
    SELECT s.competition_id, f.played, min(f.kickoff) AS date, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm FROM ((games f LEFT JOIN groups g ON ((f.group_id = g.id))) LEFT JOIN stages s ON ((g.stage_id = s.id))) GROUP BY s.competition_id, f.played, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text), to_char(f.kickoff, 'YYYYMMDD'::text), to_char(f.kickoff, 'YYYYMM'::text);


--
-- Name: game_months; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW game_months AS
    SELECT s.competition_id, f.played, min(f.kickoff) AS date, to_char(f.kickoff, 'Month YYYY'::text) AS pretty_date, to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm FROM ((games f LEFT JOIN groups g ON ((f.group_id = g.id))) LEFT JOIN stages s ON ((g.stage_id = s.id))) GROUP BY s.competition_id, f.played, to_char(f.kickoff, 'Month YYYY'::text), to_char(f.kickoff, 'YYYYMM'::text);


--
-- Name: groups_teams; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE groups_teams (
    group_id integer NOT NULL,
    team_id integer NOT NULL
);


--
-- Name: home_teams; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW home_teams AS
    SELECT teams.id, teams.organisation_id, teams.title, teams.slug, teams.created_on, teams.updated_on FROM teams;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE invites (
    id serial NOT NULL,
    code character varying(255) NOT NULL,
    recipient character varying(255),
    used boolean DEFAULT false,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: matches; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW matches AS
    SELECT g.stage_id, s.competition_id, c.season_id, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, to_char(f.kickoff, 'Dy FMHH:MIam'::text) AS pretty_time, to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm, f.id, f.group_id, f.kickoff, f.hometeam_id, f.home_score, f.home_notes, f.home_points, f.awayteam_id, f.away_score, f.away_notes, f.away_points, f.summary, f.played, f.created_on, f.updated_on FROM (((games f LEFT JOIN groups g ON ((f.group_id = g.id))) LEFT JOIN stages s ON ((g.stage_id = s.id))) LEFT JOIN competitions c ON ((s.competition_id = c.id)));


--
-- Name: modifications; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE modifications (
    id serial NOT NULL,
    group_id integer,
    team_id integer,
    value integer NOT NULL,
    notes character varying(512) NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: notices; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE notices (
    id serial NOT NULL,
    organisation_id integer,
    user_id integer,
    heading character varying(128) NOT NULL,
    slug character varying(128) NOT NULL,
    content text NOT NULL,
    picture character varying(256),
    comments_count integer DEFAULT 0,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE organisations (
    id serial NOT NULL,
    sport_id integer,
    title character varying(128) NOT NULL,
    nickname character varying(32) NOT NULL,
    summary character varying(512) NOT NULL,
    seasons_count integer DEFAULT 0,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    logo character varying(200)
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE pages (
    id serial NOT NULL,
    organisation_id integer,
    title character varying(128) NOT NULL,
    slug character varying(128) NOT NULL,
    content text NOT NULL,
    picture character varying(256),
    "position" integer NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    label character varying(32)
);


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE schema_info (
    version integer
);


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE seasons (
    id serial NOT NULL,
    organisation_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    competitions_count integer DEFAULT 0,
    is_complete boolean DEFAULT false,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE sessions (
    id serial NOT NULL,
    session_id character varying(255),
    data text,
    updated_at timestamp without time zone
);


--
-- Name: sports; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE sports (
    id serial NOT NULL,
    title character varying(64) NOT NULL,
    uses_scores boolean DEFAULT true,
    uses_manual_points boolean DEFAULT false,
    uses_teams boolean DEFAULT true,
    uses_kits boolean DEFAULT true
);


--
-- Name: standings; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW standings AS
    SELECT gt.team_id AS id, gt.group_id, gt.team_id, sum(CASE WHEN (g.hometeam_id = gt.team_id) THEN 1 ELSE 0 END) AS homeplayed, COALESCE(sum(CASE WHEN ((g.hometeam_id = gt.team_id) AND (g.home_score > g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS homewon, COALESCE(sum(CASE WHEN ((g.hometeam_id = gt.team_id) AND (g.home_score = g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS homedrawn, COALESCE(sum(CASE WHEN ((g.hometeam_id = gt.team_id) AND (g.home_score < g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS homelost, COALESCE(sum(CASE WHEN (g.hometeam_id = gt.team_id) THEN g.home_score ELSE 0 END), (0)::bigint) AS homefor, COALESCE(sum(CASE WHEN (g.hometeam_id = gt.team_id) THEN g.away_score ELSE 0 END), (0)::bigint) AS homeagainst, sum(CASE WHEN (g.awayteam_id = gt.team_id) THEN 1 ELSE 0 END) AS awayplayed, COALESCE(sum(CASE WHEN ((g.awayteam_id = gt.team_id) AND (g.home_score > g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS awaylost, COALESCE(sum(CASE WHEN ((g.awayteam_id = gt.team_id) AND (g.home_score = g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS awaydrawn, COALESCE(sum(CASE WHEN ((g.awayteam_id = gt.team_id) AND (g.home_score < g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS awaywon, COALESCE(sum(CASE WHEN (g.awayteam_id = gt.team_id) THEN g.home_score ELSE 0 END), (0)::bigint) AS awayagainst, COALESCE(sum(CASE WHEN (g.awayteam_id = gt.team_id) THEN g.away_score ELSE 0 END), (0)::bigint) AS awayfor, COALESCE(sum(CASE WHEN (g.hometeam_id = gt.team_id) THEN g.home_points ELSE g.away_points END), (0)::bigint) AS totalpoints FROM (groups_teams gt LEFT JOIN games g ON ((((g.group_id = gt.group_id) AND ((gt.team_id = g.hometeam_id) OR (gt.team_id = g.awayteam_id))) AND (g.played = true)))) GROUP BY gt.group_id, gt.team_id;


--
-- Name: team_game_days; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW team_game_days AS
    SELECT t.id AS team_id, s.competition_id, f.played, min(f.kickoff) AS date, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm FROM (((teams t JOIN games f ON (((f.hometeam_id = t.id) OR (f.awayteam_id = t.id)))) JOIN groups g ON ((f.group_id = g.id))) JOIN stages s ON ((g.stage_id = s.id))) GROUP BY t.id, s.competition_id, f.played, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text), to_char(f.kickoff, 'YYYYMMDD'::text), to_char(f.kickoff, 'YYYYMM'::text);


--
-- Name: team_matches; Type: VIEW; Schema: public; Owner: slatter
--

CREATE VIEW team_matches AS
    SELECT t.id AS team_id, g.stage_id, s.competition_id, c.season_id, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, to_char(f.kickoff, 'Dy FMHH:MIam'::text) AS pretty_time, to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm, f.id, f.group_id, f.kickoff, f.hometeam_id, f.home_score, f.home_notes, f.home_points, f.awayteam_id, f.away_score, f.away_notes, f.away_points, f.summary, f.played, f.created_on, f.updated_on FROM ((((teams t JOIN games f ON (((f.hometeam_id = t.id) OR (f.awayteam_id = t.id)))) JOIN groups g ON ((f.group_id = g.id))) JOIN stages s ON ((g.stage_id = s.id))) JOIN competitions c ON ((s.competition_id = c.id)));


--
-- Name: users; Type: TABLE; Schema: public; Owner: slatter; Tablespace: 
--

CREATE TABLE users (
    id serial NOT NULL,
    organisation_id integer,
    email character varying(256) NOT NULL,
    "password" character varying(256) NOT NULL,
    name character varying(128) NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: competitions_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY competitions
    ADD CONSTRAINT competitions_pkey PRIMARY KEY (id);


--
-- Name: contact_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY contact_responses
    ADD CONSTRAINT contact_responses_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: invites_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: modifications_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY modifications
    ADD CONSTRAINT modifications_pkey PRIMARY KEY (id);


--
-- Name: notices_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY notices
    ADD CONSTRAINT notices_pkey PRIMARY KEY (id);


--
-- Name: organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sports_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY sports
    ADD CONSTRAINT sports_pkey PRIMARY KEY (id);


--
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: slatter; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: comments_notice_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX comments_notice_id ON comments USING btree (notice_id);


--
-- Name: competitions_season_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX competitions_season_id ON competitions USING btree (season_id);


--
-- Name: competitions_season_id_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX competitions_season_id_key ON competitions USING btree (season_id, title);


--
-- Name: competitions_season_id_key1; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX competitions_season_id_key1 ON competitions USING btree (slug, season_id);


--
-- Name: competitions_season_id_key2; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX competitions_season_id_key2 ON competitions USING btree ("position", season_id);


--
-- Name: games_awayteam_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX games_awayteam_id ON games USING btree (awayteam_id);


--
-- Name: games_group_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX games_group_id ON games USING btree (group_id);


--
-- Name: games_hometeam_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX games_hometeam_id ON games USING btree (hometeam_id);


--
-- Name: groups_stage_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX groups_stage_id ON groups USING btree (stage_id);


--
-- Name: groups_stage_id_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX groups_stage_id_key ON groups USING btree (stage_id, title);


--
-- Name: groups_stage_id_key1; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX groups_stage_id_key1 ON groups USING btree (stage_id, slug);


--
-- Name: groups_teams_group_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX groups_teams_group_id ON groups_teams USING btree (group_id);


--
-- Name: groups_teams_team_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX groups_teams_team_id ON groups_teams USING btree (team_id);


--
-- Name: modifications_group_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX modifications_group_id ON modifications USING btree (group_id);


--
-- Name: modifications_team_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX modifications_team_id ON modifications USING btree (team_id);


--
-- Name: notices_organisation_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX notices_organisation_id ON notices USING btree (organisation_id);


--
-- Name: notices_organisation_id_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX notices_organisation_id_key ON notices USING btree (organisation_id, heading);


--
-- Name: notices_organisation_id_key1; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX notices_organisation_id_key1 ON notices USING btree (organisation_id, slug);


--
-- Name: organisations_nickname_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX organisations_nickname_key ON organisations USING btree (nickname);


--
-- Name: organisations_sport_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX organisations_sport_id ON organisations USING btree (sport_id);


--
-- Name: organisations_title_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX organisations_title_key ON organisations USING btree (title);


--
-- Name: pages_organisation_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX pages_organisation_id ON pages USING btree (organisation_id);


--
-- Name: pages_organisation_id_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX pages_organisation_id_key ON pages USING btree (organisation_id, title);


--
-- Name: pages_organisation_id_key1; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX pages_organisation_id_key1 ON pages USING btree (organisation_id, slug);


--
-- Name: seasons_organisation_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX seasons_organisation_id ON seasons USING btree (organisation_id);


--
-- Name: seasons_organisation_id_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX seasons_organisation_id_key ON seasons USING btree (organisation_id, title);


--
-- Name: seasons_organisation_id_key1; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX seasons_organisation_id_key1 ON seasons USING btree (organisation_id, slug);


--
-- Name: sessions_session_id_index; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX sessions_session_id_index ON sessions USING btree (session_id);


--
-- Name: sports_title_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX sports_title_key ON sports USING btree (title);


--
-- Name: stages_competition_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX stages_competition_id ON stages USING btree (competition_id);


--
-- Name: stages_competition_id_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX stages_competition_id_key ON stages USING btree (competition_id, title);


--
-- Name: stages_competition_id_key1; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX stages_competition_id_key1 ON stages USING btree (slug, competition_id);


--
-- Name: stages_competition_id_key2; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX stages_competition_id_key2 ON stages USING btree ("position", competition_id);


--
-- Name: teams_organisation_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX teams_organisation_id ON teams USING btree (organisation_id);


--
-- Name: teams_organisation_id_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX teams_organisation_id_key ON teams USING btree (organisation_id, title);


--
-- Name: teams_organisation_id_key1; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX teams_organisation_id_key1 ON teams USING btree (organisation_id, slug);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE UNIQUE INDEX users_email_key ON users USING btree (email);


--
-- Name: users_organisation_id; Type: INDEX; Schema: public; Owner: slatter; Tablespace: 
--

CREATE INDEX users_organisation_id ON users USING btree (organisation_id);


INSERT INTO schema_info (version) VALUES (6)