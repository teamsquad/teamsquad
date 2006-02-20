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
-- Name: comments; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE comments (
    id serial NOT NULL,
    notice_id integer,
    name character varying(128),
    content text NOT NULL,
    ip_address character varying(16),
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: competitions; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE competitions (
    id serial NOT NULL,
    season_id integer,
    title character varying(64) NOT NULL,
    summary text,
    rank integer NOT NULL,
    stages_count integer DEFAULT 0,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: games; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
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
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE groups (
    id serial NOT NULL,
    stage_id integer,
    title character varying(64) NOT NULL,
    games_count integer DEFAULT 0,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: groups_teams; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE groups_teams (
    group_id integer NOT NULL,
    team_id integer NOT NULL
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE teams (
    id serial NOT NULL,
    organisation_id integer,
    title character varying(64) NOT NULL,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: matches; Type: VIEW; Schema: public; Owner: sid
--

CREATE VIEW matches AS
    SELECT f.id, f.group_id, f.kickoff, f.hometeam_id, f.home_score, f.home_notes, f.home_points, f.awayteam_id, f.away_score, f.away_notes, f.away_points, f.summary, f.played, f.created_on, f.updated_on, ht.title AS hometeam_title, "at".title AS awayteam_title FROM ((games f LEFT JOIN teams ht ON ((f.hometeam_id = ht.id))) LEFT JOIN teams "at" ON ((f.awayteam_id = "at".id))) WHERE (f.played = false) ORDER BY f.kickoff;


--
-- Name: modifications; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE modifications (
    id serial NOT NULL,
    group_id integer,
    team_id integer,
    value integer NOT NULL,
    notes character varying(512) NOT NULL,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: notices; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE notices (
    id serial NOT NULL,
    organisation_id integer,
    user_id integer,
    heading character varying(128) NOT NULL,
    content text NOT NULL,
    picture character varying(256),
    comments_count integer DEFAULT 0,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE organisations (
    id serial NOT NULL,
    sport_id integer,
    title character varying(64) NOT NULL,
    nickname character varying(32) NOT NULL,
    summary character varying(512) NOT NULL,
    seasons_count integer DEFAULT 0,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: pages; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE pages (
    id serial NOT NULL,
    organisation_id integer,
    title character varying(128) NOT NULL,
    content text NOT NULL,
    picture character varying(256),
    rank integer NOT NULL,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: results; Type: VIEW; Schema: public; Owner: sid
--

CREATE VIEW results AS
    SELECT f.id, f.group_id, f.kickoff, f.hometeam_id, f.home_score, f.home_notes, f.home_points, f.awayteam_id, f.away_score, f.away_notes, f.away_points, f.summary, f.played, f.created_on, f.updated_on, ht.title AS hometeam_title, "at".title AS awayteam_title FROM ((games f LEFT JOIN teams ht ON ((f.hometeam_id = ht.id))) LEFT JOIN teams "at" ON ((f.awayteam_id = "at".id))) WHERE (f.played = true) ORDER BY f.kickoff DESC;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE schema_info (
    version integer
);


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE seasons (
    id serial NOT NULL,
    organisation_id integer,
    title character varying(64) NOT NULL,
    competitions_count integer DEFAULT 0,
    is_complete boolean DEFAULT false,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: sports; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE sports (
    id serial NOT NULL,
    title character varying(64) NOT NULL,
    uses_scores boolean DEFAULT true,
    uses_manual_points boolean DEFAULT false
);


--
-- Name: stages; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE stages (
    id serial NOT NULL,
    competition_id integer,
    title character varying(64) NOT NULL,
    rank integer NOT NULL,
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
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: standings; Type: VIEW; Schema: public; Owner: sid
--

CREATE VIEW standings AS
    SELECT gt.group_id, t.id, t.title, sum(CASE WHEN (g.hometeam_id = t.id) THEN 1 ELSE 0 END) AS homeplayed, COALESCE(sum(CASE WHEN ((g.hometeam_id = t.id) AND (g.home_score > g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS homewon, COALESCE(sum(CASE WHEN ((g.hometeam_id = t.id) AND (g.home_score = g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS homedrawn, COALESCE(sum(CASE WHEN ((g.hometeam_id = t.id) AND (g.home_score < g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS homelost, COALESCE(sum(CASE WHEN (g.hometeam_id = t.id) THEN g.home_score ELSE 0 END), (0)::bigint) AS homefor, COALESCE(sum(CASE WHEN (g.hometeam_id = t.id) THEN g.away_score ELSE 0 END), (0)::bigint) AS homeagainst, sum(CASE WHEN (g.awayteam_id = t.id) THEN 1 ELSE 0 END) AS awayplayed, COALESCE(sum(CASE WHEN ((g.awayteam_id = t.id) AND (g.home_score > g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS awaylost, COALESCE(sum(CASE WHEN ((g.awayteam_id = t.id) AND (g.home_score = g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS awaydrawn, COALESCE(sum(CASE WHEN ((g.awayteam_id = t.id) AND (g.home_score < g.away_score)) THEN 1 ELSE NULL::integer END), (0)::bigint) AS awaywon, COALESCE(sum(CASE WHEN (g.awayteam_id = t.id) THEN g.home_score ELSE 0 END), (0)::bigint) AS awayagainst, COALESCE(sum(CASE WHEN (g.awayteam_id = t.id) THEN g.away_score ELSE 0 END), (0)::bigint) AS awayfor, COALESCE(sum(CASE WHEN (g.hometeam_id = t.id) THEN g.home_points ELSE g.away_points END), (0)::bigint) AS totalpoints FROM ((groups_teams gt LEFT JOIN teams t ON ((t.id = gt.team_id))) LEFT JOIN games g ON ((((g.group_id = gt.group_id) AND ((t.id = g.hometeam_id) OR (t.id = g.awayteam_id))) AND (g.played = true)))) GROUP BY gt.group_id, t.id, t.title;


--
-- Name: users; Type: TABLE; Schema: public; Owner: sid; Tablespace: 
--

CREATE TABLE users (
    id serial NOT NULL,
    organisation_id integer,
    email character varying(256) NOT NULL,
    "password" character varying(256) NOT NULL,
    name character varying(128) NOT NULL,
    created_on timestamp without time zone DEFAULT now(),
    updated_on timestamp without time zone DEFAULT now()
);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: competitions_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY competitions
    ADD CONSTRAINT competitions_pkey PRIMARY KEY (id);


--
-- Name: competitions_season_id_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY competitions
    ADD CONSTRAINT competitions_season_id_key UNIQUE (season_id, title);


--
-- Name: competitions_season_id_key1; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY competitions
    ADD CONSTRAINT competitions_season_id_key1 UNIQUE (season_id, rank);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: groups_stage_id_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_stage_id_key UNIQUE (stage_id, title);


--
-- Name: groups_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY groups_teams
    ADD CONSTRAINT groups_teams_pkey PRIMARY KEY (group_id, team_id);


--
-- Name: modifications_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY modifications
    ADD CONSTRAINT modifications_pkey PRIMARY KEY (id);


--
-- Name: notices_organisation_id_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY notices
    ADD CONSTRAINT notices_organisation_id_key UNIQUE (organisation_id, heading);


--
-- Name: notices_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY notices
    ADD CONSTRAINT notices_pkey PRIMARY KEY (id);


--
-- Name: organisations_nickname_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_nickname_key UNIQUE (nickname);


--
-- Name: organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: organisations_title_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_title_key UNIQUE (title);


--
-- Name: pages_organisation_id_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_organisation_id_key UNIQUE (organisation_id, title);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: seasons_organisation_id_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_organisation_id_key UNIQUE (organisation_id, title);


--
-- Name: seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: sports_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY sports
    ADD CONSTRAINT sports_pkey PRIMARY KEY (id);


--
-- Name: sports_title_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY sports
    ADD CONSTRAINT sports_title_key UNIQUE (title);


--
-- Name: stages_competition_id_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_competition_id_key UNIQUE (competition_id, title);


--
-- Name: stages_competition_id_key1; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_competition_id_key1 UNIQUE (competition_id, rank);


--
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: teams_organisation_id_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_organisation_id_key UNIQUE (organisation_id, title);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: sid; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: comments_notice_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX comments_notice_id ON comments USING btree (notice_id);


--
-- Name: competitions_season_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX competitions_season_id ON competitions USING btree (season_id);


--
-- Name: games_awayteam_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX games_awayteam_id ON games USING btree (awayteam_id);


--
-- Name: games_hometeam_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX games_hometeam_id ON games USING btree (hometeam_id);


--
-- Name: groups_stage_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX groups_stage_id ON groups USING btree (stage_id);


--
-- Name: modifications_group_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX modifications_group_id ON modifications USING btree (group_id);


--
-- Name: modifications_team_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX modifications_team_id ON modifications USING btree (team_id);


--
-- Name: notices_organisation_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX notices_organisation_id ON notices USING btree (organisation_id);


--
-- Name: organisations_sport_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX organisations_sport_id ON organisations USING btree (sport_id);


--
-- Name: pages_organisation_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX pages_organisation_id ON pages USING btree (organisation_id);


--
-- Name: seasons_organisation_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX seasons_organisation_id ON seasons USING btree (organisation_id);


--
-- Name: stages_competition_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX stages_competition_id ON stages USING btree (competition_id);


--
-- Name: teams_organisation_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX teams_organisation_id ON teams USING btree (organisation_id);


--
-- Name: users_organisation_id; Type: INDEX; Schema: public; Owner: sid; Tablespace: 
--

CREATE INDEX users_organisation_id ON users USING btree (organisation_id);


--
-- Name: comments_notice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_notice_id_fkey FOREIGN KEY (notice_id) REFERENCES notices(id) ON DELETE CASCADE;


--
-- Name: competitions_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY competitions
    ADD CONSTRAINT competitions_season_id_fkey FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE CASCADE;


--
-- Name: games_awayteam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_awayteam_id_fkey FOREIGN KEY (awayteam_id) REFERENCES teams(id) ON DELETE CASCADE;


--
-- Name: games_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;


--
-- Name: games_hometeam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_hometeam_id_fkey FOREIGN KEY (hometeam_id) REFERENCES teams(id) ON DELETE CASCADE;


--
-- Name: groups_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES stages(id) ON DELETE CASCADE;


--
-- Name: groups_teams_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY groups_teams
    ADD CONSTRAINT groups_teams_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;


--
-- Name: groups_teams_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY groups_teams
    ADD CONSTRAINT groups_teams_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE;


--
-- Name: modifications_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY modifications
    ADD CONSTRAINT modifications_group_id_fkey FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE;


--
-- Name: modifications_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY modifications
    ADD CONSTRAINT modifications_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE CASCADE;


--
-- Name: notices_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY notices
    ADD CONSTRAINT notices_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE CASCADE;


--
-- Name: notices_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY notices
    ADD CONSTRAINT notices_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;


--
-- Name: organisations_sport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_sport_id_fkey FOREIGN KEY (sport_id) REFERENCES sports(id) ON DELETE CASCADE;


--
-- Name: pages_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE CASCADE;


--
-- Name: seasons_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE CASCADE;


--
-- Name: stages_competition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_competition_id_fkey FOREIGN KEY (competition_id) REFERENCES competitions(id) ON DELETE CASCADE;


--
-- Name: teams_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE CASCADE;


--
-- Name: users_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sid
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES organisations(id) ON DELETE CASCADE;


INSERT INTO schema_info (version) VALUES (2)