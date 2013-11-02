--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    organisation_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: away_teams; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW away_teams AS
 SELECT teams.id, 
    teams.organisation_id, 
    teams.title, 
    teams.slug, 
    teams.created_on, 
    teams.updated_on
   FROM teams;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    notice_id integer,
    name character varying(128),
    content text NOT NULL,
    ip_address character varying(16),
    user_agent character varying(128),
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: competitions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE competitions (
    id integer NOT NULL,
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
-- Name: competitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE competitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE competitions_id_seq OWNED BY competitions.id;


--
-- Name: contact_responses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE contact_responses (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    message text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    resolved boolean DEFAULT false
);


--
-- Name: contact_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE contact_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE contact_responses_id_seq OWNED BY contact_responses.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
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
-- Name: groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    stage_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    games_count integer DEFAULT 0,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: stages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stages (
    id integer NOT NULL,
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
-- Name: game_days; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW game_days AS
 SELECT s.id AS stage_id, 
    s.competition_id, 
    f.played, 
    min(f.kickoff) AS date, 
    to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, 
    to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, 
    to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm
   FROM ((games f
   LEFT JOIN groups g ON ((f.group_id = g.id)))
   LEFT JOIN stages s ON ((g.stage_id = s.id)))
  GROUP BY s.id, s.competition_id, f.played, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text), to_char(f.kickoff, 'YYYYMMDD'::text), to_char(f.kickoff, 'YYYYMM'::text);


--
-- Name: game_months; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW game_months AS
 SELECT s.competition_id, 
    f.played, 
    min(f.kickoff) AS date, 
    to_char(f.kickoff, 'Month YYYY'::text) AS pretty_date, 
    to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm
   FROM ((games f
   LEFT JOIN groups g ON ((f.group_id = g.id)))
   LEFT JOIN stages s ON ((g.stage_id = s.id)))
  GROUP BY s.competition_id, f.played, to_char(f.kickoff, 'Month YYYY'::text), to_char(f.kickoff, 'YYYYMM'::text);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: groups_teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups_teams (
    group_id integer NOT NULL,
    team_id integer NOT NULL
);


--
-- Name: home_teams; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW home_teams AS
 SELECT teams.id, 
    teams.organisation_id, 
    teams.title, 
    teams.slug, 
    teams.created_on, 
    teams.updated_on
   FROM teams;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invites (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    recipient character varying(255),
    used boolean DEFAULT false,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invites_id_seq OWNED BY invites.id;


--
-- Name: matches; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW matches AS
 SELECT g.stage_id, 
    s.competition_id, 
    c.season_id, 
    to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, 
    to_char(f.kickoff, 'FMHH:MIam'::text) AS pretty_time, 
    to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, 
    to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm, 
    f.id, 
    f.group_id, 
    f.kickoff, 
    f.hometeam_id, 
    f.home_score, 
    f.home_notes, 
    f.home_points, 
    f.awayteam_id, 
    f.away_score, 
    f.away_notes, 
    f.away_points, 
    f.summary, 
    f.played, 
    f.created_on, 
    f.updated_on
   FROM (((games f
   LEFT JOIN groups g ON ((f.group_id = g.id)))
   LEFT JOIN stages s ON ((g.stage_id = s.id)))
   LEFT JOIN competitions c ON ((s.competition_id = c.id)));


--
-- Name: modifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE modifications (
    id integer NOT NULL,
    group_id integer,
    team_id integer,
    value integer NOT NULL,
    notes character varying(512) NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: modifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE modifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE modifications_id_seq OWNED BY modifications.id;


--
-- Name: notices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notices (
    id integer NOT NULL,
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
-- Name: notices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notices_id_seq OWNED BY notices.id;


--
-- Name: organisations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organisations (
    id integer NOT NULL,
    sport_id integer,
    title character varying(128) NOT NULL,
    nickname character varying(32) NOT NULL,
    summary character varying(512) NOT NULL,
    theme character varying(32) DEFAULT 'classic'::character varying,
    seasons_count integer DEFAULT 0,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    logo character varying(200)
);


--
-- Name: organisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organisations_id_seq OWNED BY organisations.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
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
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: seasons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seasons (
    id integer NOT NULL,
    organisation_id integer,
    title character varying(64) NOT NULL,
    slug character varying(128) NOT NULL,
    competitions_count integer DEFAULT 0,
    is_complete boolean DEFAULT false,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: seasons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seasons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seasons_id_seq OWNED BY seasons.id;


--
-- Name: sports; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sports (
    id integer NOT NULL,
    title character varying(64) NOT NULL,
    uses_scores boolean DEFAULT true,
    uses_manual_points boolean DEFAULT false,
    uses_teams boolean DEFAULT true,
    uses_kits boolean DEFAULT true
);


--
-- Name: sports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sports_id_seq OWNED BY sports.id;


--
-- Name: stages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stages_id_seq OWNED BY stages.id;


--
-- Name: standings; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW standings AS
 SELECT gt.team_id AS id, 
    gt.group_id, 
    gt.team_id, 
    sum(
        CASE
            WHEN (g.hometeam_id = gt.team_id) THEN 1
            ELSE 0
        END) AS homeplayed, 
    COALESCE(sum(
        CASE
            WHEN ((g.hometeam_id = gt.team_id) AND (g.home_score > g.away_score)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS homewon, 
    COALESCE(sum(
        CASE
            WHEN ((g.hometeam_id = gt.team_id) AND (g.home_score = g.away_score)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS homedrawn, 
    COALESCE(sum(
        CASE
            WHEN ((g.hometeam_id = gt.team_id) AND (g.home_score < g.away_score)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS homelost, 
    COALESCE(sum(
        CASE
            WHEN (g.hometeam_id = gt.team_id) THEN g.home_score
            ELSE 0
        END), (0)::bigint) AS homefor, 
    COALESCE(sum(
        CASE
            WHEN (g.hometeam_id = gt.team_id) THEN g.away_score
            ELSE 0
        END), (0)::bigint) AS homeagainst, 
    sum(
        CASE
            WHEN (g.awayteam_id = gt.team_id) THEN 1
            ELSE 0
        END) AS awayplayed, 
    COALESCE(sum(
        CASE
            WHEN ((g.awayteam_id = gt.team_id) AND (g.home_score > g.away_score)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS awaylost, 
    COALESCE(sum(
        CASE
            WHEN ((g.awayteam_id = gt.team_id) AND (g.home_score = g.away_score)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS awaydrawn, 
    COALESCE(sum(
        CASE
            WHEN ((g.awayteam_id = gt.team_id) AND (g.home_score < g.away_score)) THEN 1
            ELSE NULL::integer
        END), (0)::bigint) AS awaywon, 
    COALESCE(sum(
        CASE
            WHEN (g.awayteam_id = gt.team_id) THEN g.home_score
            ELSE 0
        END), (0)::bigint) AS awayagainst, 
    COALESCE(sum(
        CASE
            WHEN (g.awayteam_id = gt.team_id) THEN g.away_score
            ELSE 0
        END), (0)::bigint) AS awayfor, 
    COALESCE(sum(
        CASE
            WHEN (g.hometeam_id = gt.team_id) THEN g.home_points
            ELSE g.away_points
        END), (0)::bigint) AS totalpoints
   FROM (groups_teams gt
   LEFT JOIN games g ON ((((g.group_id = gt.group_id) AND ((gt.team_id = g.hometeam_id) OR (gt.team_id = g.awayteam_id))) AND (g.played = true))))
  GROUP BY gt.group_id, gt.team_id;


--
-- Name: team_game_days; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW team_game_days AS
 SELECT t.id AS team_id, 
    s.competition_id, 
    f.played, 
    min(f.kickoff) AS date, 
    to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, 
    to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, 
    to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm
   FROM (((teams t
   JOIN games f ON (((f.hometeam_id = t.id) OR (f.awayteam_id = t.id))))
   JOIN groups g ON ((f.group_id = g.id)))
   JOIN stages s ON ((g.stage_id = s.id)))
  GROUP BY t.id, s.competition_id, f.played, to_char(f.kickoff, 'Day FMDDth Month YYYY'::text), to_char(f.kickoff, 'YYYYMMDD'::text), to_char(f.kickoff, 'YYYYMM'::text);


--
-- Name: team_matches; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW team_matches AS
 SELECT t.id AS team_id, 
    g.stage_id, 
    s.competition_id, 
    c.season_id, 
    to_char(f.kickoff, 'Day FMDDth Month YYYY'::text) AS pretty_date, 
    to_char(f.kickoff, 'FMHH:MIam'::text) AS pretty_time, 
    to_char(f.kickoff, 'YYYYMMDD'::text) AS yyyymmdd, 
    to_char(f.kickoff, 'YYYYMM'::text) AS yyyymm, 
    f.id, 
    f.group_id, 
    f.kickoff, 
    f.hometeam_id, 
    f.home_score, 
    f.home_notes, 
    f.home_points, 
    f.awayteam_id, 
    f.away_score, 
    f.away_notes, 
    f.away_points, 
    f.summary, 
    f.played, 
    f.created_on, 
    f.updated_on
   FROM ((((teams t
   JOIN games f ON (((f.hometeam_id = t.id) OR (f.awayteam_id = t.id))))
   JOIN groups g ON ((f.group_id = g.id)))
   JOIN stages s ON ((g.stage_id = s.id)))
   JOIN competitions c ON ((s.competition_id = c.id)));


--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    organisation_id integer,
    email character varying(256) NOT NULL,
    password character varying(256) NOT NULL,
    name character varying(128) NOT NULL,
    created_on timestamp without time zone,
    updated_on timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY competitions ALTER COLUMN id SET DEFAULT nextval('competitions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY contact_responses ALTER COLUMN id SET DEFAULT nextval('contact_responses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY modifications ALTER COLUMN id SET DEFAULT nextval('modifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notices ALTER COLUMN id SET DEFAULT nextval('notices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organisations ALTER COLUMN id SET DEFAULT nextval('organisations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seasons ALTER COLUMN id SET DEFAULT nextval('seasons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sports ALTER COLUMN id SET DEFAULT nextval('sports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stages ALTER COLUMN id SET DEFAULT nextval('stages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: competitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY competitions
    ADD CONSTRAINT competitions_pkey PRIMARY KEY (id);


--
-- Name: contact_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY contact_responses
    ADD CONSTRAINT contact_responses_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: modifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY modifications
    ADD CONSTRAINT modifications_pkey PRIMARY KEY (id);


--
-- Name: notices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notices
    ADD CONSTRAINT notices_pkey PRIMARY KEY (id);


--
-- Name: organisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organisations
    ADD CONSTRAINT organisations_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: sports_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sports
    ADD CONSTRAINT sports_pkey PRIMARY KEY (id);


--
-- Name: stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: comments_notice_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX comments_notice_id ON comments USING btree (notice_id);


--
-- Name: competitions_season_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX competitions_season_id ON competitions USING btree (season_id);


--
-- Name: competitions_season_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX competitions_season_id_key ON competitions USING btree (season_id, title);


--
-- Name: competitions_season_id_key1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX competitions_season_id_key1 ON competitions USING btree (slug, season_id);


--
-- Name: competitions_season_id_key2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX competitions_season_id_key2 ON competitions USING btree ("position", season_id);


--
-- Name: games_awayteam_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX games_awayteam_id ON games USING btree (awayteam_id);


--
-- Name: games_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX games_group_id ON games USING btree (group_id);


--
-- Name: games_hometeam_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX games_hometeam_id ON games USING btree (hometeam_id);


--
-- Name: groups_stage_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX groups_stage_id ON groups USING btree (stage_id);


--
-- Name: groups_stage_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX groups_stage_id_key ON groups USING btree (stage_id, title);


--
-- Name: groups_stage_id_key1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX groups_stage_id_key1 ON groups USING btree (stage_id, slug);


--
-- Name: groups_teams_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX groups_teams_group_id ON groups_teams USING btree (group_id);


--
-- Name: groups_teams_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX groups_teams_team_id ON groups_teams USING btree (team_id);


--
-- Name: modifications_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX modifications_group_id ON modifications USING btree (group_id);


--
-- Name: modifications_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX modifications_team_id ON modifications USING btree (team_id);


--
-- Name: notices_organisation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX notices_organisation_id ON notices USING btree (organisation_id);


--
-- Name: notices_organisation_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX notices_organisation_id_key ON notices USING btree (organisation_id, heading);


--
-- Name: notices_organisation_id_key1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX notices_organisation_id_key1 ON notices USING btree (organisation_id, slug);


--
-- Name: organisations_nickname_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX organisations_nickname_key ON organisations USING btree (nickname);


--
-- Name: organisations_sport_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organisations_sport_id ON organisations USING btree (sport_id);


--
-- Name: organisations_title_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX organisations_title_key ON organisations USING btree (title);


--
-- Name: pages_organisation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX pages_organisation_id ON pages USING btree (organisation_id);


--
-- Name: pages_organisation_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pages_organisation_id_key ON pages USING btree (organisation_id, title);


--
-- Name: pages_organisation_id_key1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX pages_organisation_id_key1 ON pages USING btree (organisation_id, slug);


--
-- Name: seasons_organisation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX seasons_organisation_id ON seasons USING btree (organisation_id);


--
-- Name: seasons_organisation_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX seasons_organisation_id_key ON seasons USING btree (organisation_id, title);


--
-- Name: seasons_organisation_id_key1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX seasons_organisation_id_key1 ON seasons USING btree (organisation_id, slug);


--
-- Name: sports_title_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX sports_title_key ON sports USING btree (title);


--
-- Name: stages_competition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX stages_competition_id ON stages USING btree (competition_id);


--
-- Name: stages_competition_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX stages_competition_id_key ON stages USING btree (competition_id, title);


--
-- Name: stages_competition_id_key1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX stages_competition_id_key1 ON stages USING btree (slug, competition_id);


--
-- Name: stages_competition_id_key2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX stages_competition_id_key2 ON stages USING btree ("position", competition_id);


--
-- Name: teams_organisation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX teams_organisation_id ON teams USING btree (organisation_id);


--
-- Name: teams_organisation_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX teams_organisation_id_key ON teams USING btree (organisation_id, title);


--
-- Name: teams_organisation_id_key1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX teams_organisation_id_key1 ON teams USING btree (organisation_id, slug);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_email_key ON users USING btree (email);


--
-- Name: users_organisation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_organisation_id ON users USING btree (organisation_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');