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

--
-- Name: composition; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE composition AS ENUM (
    'Main',
    'Reserve',
    'Double',
    'Youth',
    'Other',
    'Forward'
);


--
-- Name: coverage; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE coverage AS ENUM (
    'Synthetic',
    'Natural'
);


--
-- Name: role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE role AS ENUM (
    'Keeper',
    'Back',
    'Midfielder',
    'Forward'
);


--
-- Name: warning_card; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE warning_card AS ENUM (
    'Red',
    'Yellow'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: assists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assists (
    assist_id integer NOT NULL,
    match_id smallint,
    player_id smallint,
    moment numeric(3,0) NOT NULL,
    CONSTRAINT assists_moment_check CHECK (((moment > (0)::numeric) AND (moment < (150)::numeric)))
);


--
-- Name: assists_assist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assists_assist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assists_assist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assists_assist_id_seq OWNED BY assists.assist_id;


--
-- Name: championship; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE championship (
    championship_id integer NOT NULL,
    name character varying(128)
);


--
-- Name: championship_championship_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE championship_championship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: championship_championship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE championship_championship_id_seq OWNED BY championship.championship_id;


--
-- Name: goals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE goals (
    goal_id integer NOT NULL,
    match_id smallint,
    player_id smallint,
    moment numeric(3,0) NOT NULL,
    CONSTRAINT goals_moment_check CHECK (((moment > (0)::numeric) AND (moment < (150)::numeric)))
);


--
-- Name: goals_goal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goals_goal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goals_goal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goals_goal_id_seq OWNED BY goals.goal_id;


--
-- Name: judge; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE judge (
    judge_id integer NOT NULL,
    lname character varying(64) NOT NULL,
    fname character varying(64) NOT NULL,
    surname character varying(64),
    city character varying(64),
    birth_date date NOT NULL,
    cityzenship character varying(16)
);


--
-- Name: judge_judge_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE judge_judge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: judge_judge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE judge_judge_id_seq OWNED BY judge.judge_id;


--
-- Name: matchs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE matchs (
    match_id integer NOT NULL,
    status_id smallint,
    owner_id smallint,
    guest_id smallint,
    judge_id smallint,
    match_date date NOT NULL,
    stadium_id integer,
    viewers numeric(7,0),
    CONSTRAINT positive_viewers CHECK ((viewers >= (0)::numeric))
);


--
-- Name: matchs_match_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE matchs_match_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: matchs_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE matchs_match_id_seq OWNED BY matchs.match_id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players (
    player_id integer NOT NULL,
    fname character varying(64) NOT NULL,
    lname character varying(64) NOT NULL,
    surname character varying(64),
    birth_date date NOT NULL,
    hometown character varying(64),
    team_id smallint,
    number numeric(2,0),
    team_composition composition NOT NULL,
    team_role role NOT NULL,
    citizenship character varying(32) NOT NULL,
    height numeric(3,0),
    weight numeric(3,0),
    CONSTRAINT positive_height CHECK ((height > (0)::numeric)),
    CONSTRAINT positive_number CHECK (((number IS NOT NULL) AND (number > (0)::numeric))),
    CONSTRAINT positive_weight CHECK ((weight > (0)::numeric))
);


--
-- Name: players_player_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE players_player_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players_player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE players_player_id_seq OWNED BY players.player_id;


--
-- Name: stadium; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stadium (
    stadium_id integer NOT NULL,
    name character varying(64) NOT NULL,
    address character varying(64) NOT NULL,
    capacity integer,
    stadium_coverage coverage,
    opened smallint NOT NULL,
    CONSTRAINT positive_capacity CHECK ((capacity > 0))
);


--
-- Name: stadium_stadium_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stadium_stadium_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stadium_stadium_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stadium_stadium_id_seq OWNED BY stadium.stadium_id;


--
-- Name: team; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team (
    team_id integer NOT NULL,
    name character varying(64),
    coach character varying(64) NOT NULL,
    city character varying(64) NOT NULL,
    stadium_id smallint
);


--
-- Name: team_team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: team_team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_team_id_seq OWNED BY team.team_id;


--
-- Name: trauma; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trauma (
    trauma_id integer NOT NULL,
    match_id smallint,
    player_id smallint,
    moment numeric(3,0) NOT NULL,
    description character varying(128),
    CONSTRAINT trauma_moment_check CHECK (((moment > (0)::numeric) AND (moment < (150)::numeric)))
);


--
-- Name: trauma_trauma_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trauma_trauma_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trauma_trauma_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trauma_trauma_id_seq OWNED BY trauma.trauma_id;


--
-- Name: warnings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE warnings (
    warning_id integer NOT NULL,
    match_id smallint,
    player_id smallint,
    moment numeric(3,0) NOT NULL,
    type warning_card,
    CONSTRAINT warnings_moment_check CHECK (((moment > (0)::numeric) AND (moment < (150)::numeric)))
);


--
-- Name: warnings_warning_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE warnings_warning_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: warnings_warning_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE warnings_warning_id_seq OWNED BY warnings.warning_id;


--
-- Name: assist_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assists ALTER COLUMN assist_id SET DEFAULT nextval('assists_assist_id_seq'::regclass);


--
-- Name: championship_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY championship ALTER COLUMN championship_id SET DEFAULT nextval('championship_championship_id_seq'::regclass);


--
-- Name: goal_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals ALTER COLUMN goal_id SET DEFAULT nextval('goals_goal_id_seq'::regclass);


--
-- Name: judge_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY judge ALTER COLUMN judge_id SET DEFAULT nextval('judge_judge_id_seq'::regclass);


--
-- Name: match_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY matchs ALTER COLUMN match_id SET DEFAULT nextval('matchs_match_id_seq'::regclass);


--
-- Name: player_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY players ALTER COLUMN player_id SET DEFAULT nextval('players_player_id_seq'::regclass);


--
-- Name: stadium_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stadium ALTER COLUMN stadium_id SET DEFAULT nextval('stadium_stadium_id_seq'::regclass);


--
-- Name: team_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY team ALTER COLUMN team_id SET DEFAULT nextval('team_team_id_seq'::regclass);


--
-- Name: trauma_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trauma ALTER COLUMN trauma_id SET DEFAULT nextval('trauma_trauma_id_seq'::regclass);


--
-- Name: warning_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY warnings ALTER COLUMN warning_id SET DEFAULT nextval('warnings_warning_id_seq'::regclass);


--
-- Data for Name: assists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY assists (assist_id, match_id, player_id, moment) FROM stdin;
1	1	272	53
2	1	265	26
3	2	328	85
4	2	174	73
5	2	176	45
6	2	174	12
7	3	82	69
8	3	81	36
9	3	92	18
10	4	363	81
11	5	221	87
12	5	\N	61
13	5	62	48
14	5	221	38
15	5	70	36
16	5	221	33
17	5	62	28
18	6	\N	76
19	6	141	18
20	8	283	80
21	8	281	76
22	8	283	64
23	10	221	90
24	10	141	6
25	12	78	78
26	12	81	62
27	12	81	54
28	12	92	33
29	12	84	26
30	13	\N	87
31	13	284	58
32	14	265	17
33	15	317	60
34	16	164	83
35	16	149	53
36	18	65	62
37	18	65	31
38	19	92	73
40	21	377	4
42	22	147	21
43	22	147	5
44	23	116	64
45	23	105	57
46	23	106	26
\.


--
-- Name: assists_assist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('assists_assist_id_seq', 1, false);


--
-- Data for Name: championship; Type: TABLE DATA; Schema: public; Owner: -
--

COPY championship (championship_id, name) FROM stdin;
1	Chempionat Rossii 2014/2015
\.


--
-- Name: championship_championship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('championship_championship_id_seq', 1, false);


--
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: -
--

COPY goals (goal_id, match_id, player_id, moment) FROM stdin;
1	1	265	89
2	1	262	74
3	1	270	53
4	1	270	26
5	2	325	85
6	2	184	73
7	2	174	45
8	2	175	12
9	2	334	6
10	3	75	69
11	3	92	36
12	3	92	18
13	3	75	9
14	4	380	81
15	4	364	49
16	4	379	45
17	4	378	35
18	4	306	5
19	5	223	87
20	5	71	66
21	5	70	61
22	5	70	48
23	5	70	41
24	5	231	38
25	5	62	36
26	5	231	33
27	5	55	28
28	5	71	15
29	6	131	76
30	6	\N	18
31	8	284	88
32	8	281	80
33	8	282	76
34	8	284	64
35	9	350	53
36	10	189	90
37	10	131	65
38	10	221	25
39	10	131	6
40	11	378	79
41	12	\N	86
42	12	93	78
43	12	93	72
44	12	82	62
45	12	92	54
46	12	92	47
47	12	92	36
48	12	78	26
49	13	250	87
50	13	291	58
51	14	270	51
52	14	270	17
53	14	70	3
54	15	333	60
55	15	105	21
56	16	\N	83
57	16	153	53
58	17	24	62
59	17	296	43
60	18	71	62
61	18	55	31
62	19	\N	73
63	19	324	34
64	19	81	6
66	21	369	4
70	22	231	72
71	22	154	21
72	22	155	5
73	23	105	68
74	23	112	64
75	23	116	57
76	23	110	26
\.


--
-- Name: goals_goal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('goals_goal_id_seq', 1, false);


--
-- Data for Name: judge; Type: TABLE DATA; Schema: public; Owner: -
--

COPY judge (judge_id, lname, fname, surname, city, birth_date, cityzenship) FROM stdin;
1	Vladimir	Moskalev	Viktorovich	Voronej	1983-09-03	Rossiya
2	Sergey	Karasev	Gennadevich	Moskva	1979-06-12	Rossiya
3	Vitaliy	Meshkov	Petrovich	Dmitrov	1983-02-18	Rossiya
4	Aleksey	Matyunin	Valerevich	Moskva	1982-03-16	Rossiya
5	Kiril	Levnikov	Nikolaevich	Sankt-Peterburg	1984-02-11	Rossiya
6	Aleksandr	Egorov	Anatolevich	Saransk	1972-08-30	Rossiya
7	Igor	Nizovtsev	Nikolaevich	Nijniy Novgorod	1980-08-19	Rossiya
8	Mihail	Vilkov	\N	Nijniy Novgorod	1979-07-09	Rossiya
\.


--
-- Name: judge_judge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('judge_judge_id_seq', 1, false);


--
-- Data for Name: matchs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY matchs (match_id, status_id, owner_id, guest_id, judge_id, match_date, stadium_id, viewers) FROM stdin;
1	1	9	10	1	2014-08-01	2	12000
2	1	13	7	2	2014-08-02	9	3223
3	1	2	4	3	2014-08-02	16	15678
4	1	15	12	4	2014-08-02	10	1632
5	1	3	8	5	2014-08-03	10	4500
6	1	16	14	6	2014-08-03	5	18900
7	1	6	5	7	2014-08-03	8	21000
8	1	11	1	8	2014-08-04	6	23547
9	1	11	1	1	2014-08-04	6	23456
10	1	16	8	2	2014-08-08	5	4500
11	1	7	15	3	2014-08-09	15	23321
12	1	4	12	4	2014-08-09	1	12345
13	1	11	9	5	2014-08-09	6	32455
14	1	3	10	6	2014-08-10	10	34754
15	1	13	5	7	2014-08-10	9	16452
16	1	2	6	8	2014-08-10	16	12500
17	1	12	1	1	2014-08-12	13	37032
18	1	14	3	2	2014-08-13	14	16723
19	1	13	4	3	2014-08-13	9	43201
20	1	2	9	4	2014-08-13	16	19800
21	1	15	11	5	2014-08-13	10	12521
22	1	6	8	6	2014-08-14	8	3245
23	1	5	10	7	2014-08-14	5	15678
24	1	7	16	8	2014-08-15	15	32000
\.


--
-- Name: matchs_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('matchs_match_id_seq', 1, false);


--
-- Data for Name: players; Type: TABLE DATA; Schema: public; Owner: -
--

COPY players (player_id, fname, lname, surname, birth_date, hometown, team_id, number, team_composition, team_role, citizenship, height, weight) FROM stdin;
1	Roman	Gerus	Vladimirovich	1980-09-14	Tihoretsk	1	1	Main	Keeper	Rossiya	192	86
2	Sergey	Narubin	Vladimirovich	1981-12-05	\N	1	42	Main	Keeper	Rossiya	196	94
3	Petar	Zanev	\N	1985-10-18	\N	1	3	Main	Back	Bolgariya	180	70
4	Ivan	Cherenchikov	Andreevich	1984-08-25	Ozersk	1	23	Main	Back	Rossiya	186	82
5	Tomas	Fibel	\N	1986-05-21	\N	1	97	Main	Back	Frantsiya	192	91
6	Soslan	Takazov	Valerevich	1993-02-28	\N	1	30	Main	Back	Rossiya	186	80
7	Aleksey	Nikitin	Valerevich	1992-01-27	\N	1	6	Main	Back	Rossiya	183	72
8	Yakub	Vavrjinyak	\N	1983-07-07	Kutno	1	31	Main	Back	Polsha	186	80
9	Zahari	Sirakov	Vasilev	1977-10-08	Smolyan	1	14	Main	Back	Bolgariya	182	78
10	Dmitriy	Belorukov	Aleksandrovich	1983-03-24	Sankt-Peterburg	1	21	Main	Back	Rossiya	190	89
11	Brayn	Idovu	\N	1992-05-18	\N	1	16	Main	Back	Rossiya	178	76
12	Damian	Zbojen	\N	1989-04-25	\N	1	25	Main	Back	Polsha	186	82
13	Aleksandr	Kolomeytsev	Vladimirovich	1989-02-21	Surgut	1	19	Main	Midfielder	Rossiya	183	78
14	Igor	Kireev	Olegovich	1992-02-17	\N	1	8	Main	Midfielder	Rossiya	165	63
15	Sergey	Balanovich	Mihaylovich	1987-08-29	Pinsk	1	13	Main	Midfielder	Belarus	176	70
16	David	Dzahov	Yurevich	1989-01-18	\N	1	17	Main	Midfielder	Rossiya	184	80
17	Fegor	Ogude	\N	1987-07-29	Lagos	1	87	Main	Midfielder	Nigeriya	181	85
18	Yanush	Gol	\N	1985-11-11	\N	1	5	Reserve	Midfielder	Polsha	182	77
19	Georgi	Peev	Ivanov	1979-03-11	Sofiya	1	7	Main	Midfielder	Bolgariya	181	80
20	Branko	Yovichich	\N	1993-03-18	\N	1	33	Main	Midfielder	Serbiya	179	74
21	Alihan	Shavaev	Aslanovich	1993-01-05	\N	1	22	Main	Midfielder	Rossiya	176	70
22	Blagoy	Georgiev	\N	1981-12-21	\N	9	77	Main	Midfielder	Bolgariya	185	84
23	Pavel	Solomatin	Olegovich	1993-04-04	\N	1	88	Other	Forward	Rossiya	176	73
24	Igor	Pikuschak	Aleksandrovich	1983-03-27	\N	1	10	Reserve	Forward	Moldova	184	78
25	Martin	Yakubko	\N	1980-02-26	Preshov	1	26	Other	Forward	Slovakiya	193	95
26	Marko	Simonovski	\N	1992-01-02	\N	1	11	Reserve	Forward	Makedoniya	185	78
27	Evgeniy	Tyukalov	Evgenevich	1992-08-07	\N	1	43	Reserve	Forward	Rossiya	180	75
28	Aleksandr	Subbotin	Alekseevich	1991-10-20	\N	1	99	Main	Forward	Rossiya	179	75
29	Aleksandr	Filimonov	Vladimirovich	1973-10-15	\N	2	1	Main	Keeper	Rossiya	193	91
30	Andrey	Vasilev	Dmitrievich	1992-02-11	\N	2	4	Main	Back	Rossiya	179	70
31	Evgeniy	Osipov	Vladislavovich	1986-10-29	\N	2	19	Main	Back	Rossiya	189	87
32	Ivan	Ershov	Ivanovich	1979-05-22	\N	2	2	Main	Back	Rossiya	174	69
33	Ivan	Lozenkov	Sergeevich	1984-04-14	\N	2	3	Main	Back	Rossiya	185	79
34	Lukash	Tesak	\N	1985-03-08	\N	2	22	Main	Back	Slovakiya	176	71
35	Igor	Kaleshin	Sergeevich	1983-05-29	\N	2	23	Reserve	Back	Rossiya	185	80
36	Sergey	Suharev	Aleksandrovich	1987-01-29	\N	2	8	Main	Back	Rossiya	183	83
37	Vladislav	Ryijkov	Alekseevich	1990-07-28	\N	2	28	Reserve	Midfielder	Rossiya	172	68
38	Sergey	Kuznetsov	Gennadevich	1986-05-07	\N	2	10	Main	Midfielder	Rossiya	182	75
39	Mladen	Kashchelan	\N	1983-02-13	\N	2	18	Reserve	Midfielder	Chernogoriya	173	73
40	Andrey	Lyah	Ivanovich	1990-09-24	\N	2	90	Main	Midfielder	Rossiya	190	80
41	Aleksandr	Zotov	Vladimirovich	1990-08-27	Askiz	2	7	Reserve	Midfielder	Rossiya	175	68
42	Sergey	Maslov	Yurevich	1990-09-03	\N	2	14	Main	Midfielder	Rossiya	177	74
43	Sergey	Ignatev	Vladimirovich	1986-12-09	\N	2	27	Reserve	Midfielder	Rossiya	180	75
44	Dmitriy	Smirnov	Aleksandrovich	1980-08-13	Moskva	2	24	Reserve	Midfielder	Rossiya	197	87
45	Aleksandr	Makarenko	Aleksandrovich	1986-02-04	\N	2	88	Main	Midfielder	Rossiya	182	73
46	Maksim	Lepskiy	Stanislavovich	1985-12-07	\N	2	77	Reserve	Midfielder	Rossiya	176	73
47	Artur	Maloyan	Mihaylovich	1989-02-04	Krasnodar	2	38	Main	Forward	Rossiya	180	73
48	Aleksandr	Kutin	Stanislavovich	1986-02-13	\N	2	48	Main	Forward	Rossiya	187	76
49	Maksim	Votinov	Andreevich	1988-08-29	\N	2	99	Main	Forward	Rossiya	191	87
50	Aleksey	Bazanov	Vladimirovich	1986-01-24	\N	2	11	Main	Midfielder	Rossiya	185	79
51	Aleksey	Gogiya	Anatolevich	1989-04-07	\N	2	29	Other	Midfielder	Rossiya	176	72
52	Vladimir	Gabulov	Borisovich	1983-10-19	Mozdok	3	30	Main	Keeper	Rossiya	190	81
53	Roman	Berezovskiy	Anatolevich	1974-08-05	Erevan	3	21	Reserve	Keeper	Armeniya	188	89
54	Franku	Duglas	\N	1988-01-12	Florianopolis	3	5	Main	Back	Niderlandyi	193	80
55	Kristofer	Samba	\N	1984-03-28	\N	3	4	Main	Back	Kongo	194	94
56	Aleksandr	Byuttner	\N	1989-02-11	Dotihem	3	3	Main	Back	Niderlandyi	174	75
57	Vladimir	Granat	Vasilevich	1987-03-22	Ulan-Ude	3	13	Main	Back	Rossiya	184	78
58	Stanislav	Manolev	\N	1985-12-16	Blagoevgrad	3	23	Reserve	Back	Bolgariya	185	81
59	Tomash	Gubochan	\N	1985-09-17	Jilina	3	15	Main	Back	Slovakiya	183	74
60	Aleksey	Kozlov	Anatolevich	1986-12-25	\N	3	25	Reserve	Back	Rossiya	186	78
61	Boris	Rotenberg	Borisovich	1986-05-19	\N	3	28	Reserve	Back	Finlyandiya	188	84
62	Balaj	Djudjak	\N	1986-12-23	Debretsen	3	7	Main	Midfielder	Vengriya	179	72
63	Aleksey	Ionov	Sergeevich	1989-02-18	Kingisepp	3	11	Main	Midfielder	Rossiya	177	68
64	Uilyam	Vanker	\N	1988-11-19	\N	3	6	Main	Midfielder	Frantsiya	180	73
65	Mate	Valbuena	\N	1984-09-28	\N	3	14	Main	Midfielder	Frantsiya	167	58
66	Yuriy	Jirkov	Valentinovich	1983-08-20	Tambov	3	18	Main	Midfielder	Rossiya	180	75
67	Igor	Denisov	Vladimirovich	1984-05-17	Sankt-Peterburg	3	27	Main	Midfielder	Rossiya	176	70
68	Kristian	Noboa	\N	1985-04-08	Guayakil	3	16	Main	Midfielder	Ekvador	183	75
69	Roman	Zobnin	Sergeevich	1994-02-11	\N	3	47	Reserve	Midfielder	Rossiya	184	74
70	Aleksandr	Kokorin	Aleksandrovich	1991-03-19	Moskva	3	9	Main	Forward	Rossiya	183	79
71	Kevin	Kurani	\N	1982-03-02	Rio-de-Janeyro	3	22	Main	Forward	Germaniya	190	88
72	Aleksandr	Prudnikov	Aleksandrovich	1989-02-26	\N	3	99	Main	Forward	Rossiya	185	79
73	Anton	Shunin	Vladimirovich	1987-01-27	Moskva	3	1	Other	Keeper	Rossiya	190	83
74	Yuriy	Lodyigin	\N	1990-05-26	Vladimir	4	1	Main	Keeper	Rossiya	187	82
75	Domeniko	Krishito	\N	1986-12-30	Cherkola	4	4	Main	Back	Italiya	183	75
76	Nikolas	Lomberts	\N	1985-03-20	Bryugge	4	6	Main	Back	Belgiya	188	83
77	Esekel	Garay	\N	1986-10-10	Rosario	4	24	Main	Back	Argentina	188	80
78	Igor	Smolnikov	Aleksandrovich	1988-08-08	Kamensk-Uralskiy	4	19	Main	Back	Rossiya	181	75
79	Aleksandr	Anyukov	Gennadevich	1982-09-28	Samara	4	2	Main	Back	Rossiya	178	67
80	Luish	Netu	\N	1988-05-26	\N	4	13	Reserve	Back	Portugaliya	187	71
81	Daniel	Alvesh	\N	1983-08-07	\N	4	35	Main	Midfielder	Portugaliya	178	70
82	Oleg	Shatov	Aleksandrovich	1990-07-29	\N	4	17	Main	Midfielder	Rossiya	173	64
83	Aksel	Vitsel	\N	1989-01-12	Lyuttich	4	28	Main	Midfielder	Belgiya	186	76
84	Viktor	Fayzulin	Igorevich	1986-04-22	Nahodka	4	20	Main	Midfielder	Rossiya	176	72
85	Fransisko	Fernandes	\N	1987-02-22	Mula	4	21	Main	Midfielder	Ispaniya	186	82
86	Aleksandr	Ryazantsev	Aleksandrovich	1986-09-05	Moskva	4	5	Main	Midfielder	Rossiya	180	75
87	Andrey	Arshavin	Sergeevich	1981-05-29	\N	4	10	Reserve	Midfielder	Rossiya	172	71
88	Pavel	Mogilevets	Sergeevich	1993-01-25	\N	4	8	Reserve	Midfielder	Rossiya	183	70
89	Anatoliy	Timoschuk	Aleksandrovich	1979-03-30	\N	4	44	Reserve	Midfielder	Ukraina	181	70
90	Ramil	Sheydaev	Teymurovich	1996-03-15	\N	4	90	Other	Midfielder	Rossiya	187	77
91	Ivan	Solovev	Vladimirovich	1993-03-29	\N	4	99	Other	Midfielder	Rossiya	168	63
92	Jivanildo	De Souza	\N	1986-07-25	Kampina	4	7	Main	Forward	Braziliya	180	80
93	Aleksandr	Kerjakov	Anatolevich	1982-11-27	Kingisepp	4	11	Main	Forward	Rossiya	176	76
94	Vyacheslav	Malafeev	Aleksandrovich	1979-03-04	Sankt-Peterburg	4	16	Reserve	Keeper	Rossiya	185	76
95	Milan	Rodich	\N	1991-04-02	\N	4	33	Other	Back	Serbiya	180	73
96	Konstantin	Lobov	Yurevich	1981-05-02	\N	4	55	Other	Back	Rossiya	180	75
97	Djamaldin	Hodjaniyazov	Abduhalitovich	1996-07-18	\N	4	57	Other	Back	Rossiya	180	70
98	Andrey	Dikan	Aleksandrovich	1977-07-16	Harkov	5	31	Main	Keeper	Ukraina	192	87
99	Andrey	Sinitsyin	Alekseevich	1988-06-23	\N	5	88	Reserve	Keeper	Rossiya	196	85
100	Artur	Endjeychik	\N	1987-11-04	\N	5	5	Main	Back	Polsha	188	82
101	Andreas	Grankvist	\N	1985-04-16	Helsingborg	5	6	Main	Back	Shvetsiya	192	84
102	Ragnar	Sigurdsson	\N	1986-06-19	Reyk'yavik	5	27	Main	Back	Islandiya	187	77
103	Vitaliy	Kaleshin	Igorevich	1980-10-03	Krasnodar	5	17	Main	Back	Rossiya	173	69
104	Aleksandr	Martyinovich	Vladimirovich	1987-08-26	\N	5	4	Main	Back	Belarus	192	83
105	Joao Natailton	Dos Santos	\N	1988-12-25	\N	5	22	Main	Midfielder	Braziliya	163	60
106	Yuriy	Gazinskiy	Aleksandrovich	1989-07-20	\N	5	8	Main	Midfielder	Rossiya	184	75
107	Rikardo	Laborde	\N	1988-02-16	\N	5	21	Reserve	Midfielder	Kolumbiya	173	73
108	Odil	Ahmedov	\N	1987-11-25	\N	5	10	Main	Midfielder	Uzbekistan	180	72
109	Maurisio	Pereyra	\N	1990-03-15	\N	5	33	Main	Midfielder	Urugvay	174	67
110	Marat	Izmaylov	Nailevich	1982-09-21	\N	5	11	Main	Midfielder	Rossiya	172	70
111	Sergey	Petrov	Andreevich	1991-01-02	\N	5	98	Main	Midfielder	Rossiya	175	71
112	Vladimir	Byistrov	Sergeevich	1984-01-31	Luga	5	18	Other	Midfielder	Rossiya	177	73
113	Pavel	Mamaev	Konstantinovich	1988-09-17	\N	5	7	Main	Midfielder	Rossiya	178	70
114	Ruslan	Adjindjal	Alekseevich	1974-06-22	Gagra	5	20	Reserve	Midfielder	Abhaziya	168	65
115	Fransisko Vanderson	Karneyro do Karmo	\N	1986-02-18	Baturite	5	14	Main	Forward	Braziliya	180	75
116	Arislenes	Da Silva	\N	1985-12-11	Fortaleza	5	9	Main	Forward	Braziliya	180	85
117	Nikita	Burmistrov	Aleksandrovich	1989-07-06	\N	5	19	Main	Forward	Rossiya	184	73
118	Nikolay	Markov	Valerevich	1985-04-20	\N	5	2	Other	Back	Uzbekistan	178	72
119	Evgeniy	Shipitsin	Fedorovich	1985-01-16	\N	5	25	Other	Midfielder	Rossiya	179	74
120	Nikolay	Komlichenko	Nikolaevich	1995-06-29	\N	5	63	Other	Forward	Rossiya	193	91
121	Aleksandr	Belenov	Vasilevich	1986-09-13	Belgorod	16	23	Main	Keeper	Rossiya	197	91
122	Aleshandre	Luiz Rime	\N	1988-02-23	\N	16	4	Main	Back	Braziliya	193	88
123	Toni	Shunich	\N	1988-12-15	\N	16	14	Main	Back	Bosniya_i_Gertsegovina	192	80
125	Andrey	Eschenko	Olegovich	1984-02-09	Irkutsk	16	38	Main	Back	Rossiya	170	62
126	Roman	Bugaev	Igorevich	1989-02-11	\N	16	43	Reserve	Back	Rossiya	181	70
127	Igor	Armash	Andreevich	1987-07-14	Kishinev	16	2	Main	Back	Moldova	194	82
128	Vladislav	Kulik	Mihaylovich	1985-02-27	Poltava	16	7	Main	Midfielder	Rossiya	180	76
130	Sharl	Kabore	\N	1988-02-09	\N	16	10	Main	Midfielder	Burkina_Faso	181	75
131	Ivelin	Popov	\N	1987-10-26	Sofiya	16	71	Main	Midfielder	Bolgariya	182	78
132	Mohammed	Rabiu	\N	1989-12-31	Akkra	16	21	Other	Midfielder	Gana	187	70
133	Anton	Sosnin	Vasilevich	1990-01-27	\N	16	22	Main	Midfielder	Rossiya	178	72
134	Seku	Olise	\N	1990-06-05	\N	16	26	Main	Midfielder	Liberiya	178	70
135	Arsen	Hubulov	Davidovich	1990-12-13	\N	16	9	Reserve	Midfielder	Rossiya	181	74
136	Artur	Tlisov	Ruslanovich	1982-06-10	Cherkessk	16	8	Reserve	Midfielder	Rossiya	180	72
137	Lorentso	Melgareho	\N	1990-08-10	Loma	16	25	Reserve	Midfielder	Paragvay	178	70
139	Maksim	Javnerchik	Anatolevich	1985-02-09	Soligorsk	16	15	Reserve	Midfielder	Belarus	179	70
140	George	Bukur	\N	1980-04-08	Buharest	16	11	Main	Forward	Rumyiniya	171	66
141	Danilo Chirino	De Oliveyra	\N	1986-11-12	Sorokaba	16	19	Main	Forward	Braziliya	186	80
142	Ibrahima	Balde	\N	1990-09-01	\N	16	99	Main	Forward	Senegal	190	82
143	Eduard	Baychora	Muratovich	1992-02-04	\N	16	1	Reserve	Keeper	Rossiya	194	85
144	Ilya	Abaev	Viktorovich	1981-08-02	\N	6	81	Main	Keeper	Rossiya	192	83
145	Gilerme Alvim	Marinato	\N	1985-12-12	Kataguazis	6	1	Reserve	Keeper	Braziliya	197	78
146	Yan	Dyuritsa	\N	1981-12-10	Dunayska	6	28	Main	Back	Slovakiya	187	85
147	Vitaliy	Denisov	Gennadevich	1987-02-23	\N	6	29	Other	Back	Uzbekistan	178	75
148	Vedran	Chorluka	\N	1986-02-05	\N	6	14	Main	Back	Horvatiya	192	84
149	Renat	Yanbaev	Rudolfovich	1984-04-07	Krasnodar	6	55	Main	Back	Rossiya	178	71
150	Roman	Shishkin	Aleksandrovich	1987-01-27	Voronej	6	49	Reserve	Back	Rossiya	177	67
151	Taras	Mihalik	Vladimirovich	1983-10-28	\N	6	17	Main	Back	Ukraina	184	83
152	Nemanya	Peychinovich	\N	1986-11-04	Kraguevats	6	5	Reserve	Back	Serbiya	185	81
153	Manuel	Fernandesh	\N	1986-02-05	Lissabon	6	4	Main	Midfielder	Portugaliya	176	72
154	Aleksandr	Samedov	Sergeevich	1984-07-19	Moskva	6	19	Main	Midfielder	Rossiya	177	75
155	Alan	Kasaev	Taymurazovich	1986-04-08	Vladikavkaz	6	3	Main	Midfielder	Rossiya	175	72
156	Aleksandr	Sheshukov	Sergeevich	1983-04-15	Omsk	6	8	Main	Midfielder	Rossiya	180	75
157	Mubarak	Bussufa	\N	1984-08-15	Amsterdam	6	11	Main	Midfielder	Marokko	167	61
158	Aleksey	Miranchuk	Andreevich	1995-10-17	\N	6	59	Reserve	Midfielder	Rossiya	177	67
159	Dmitriy	Tarasov	Alekseevich	1987-03-18	Moskva	6	23	Other	Midfielder	Rossiya	188	73
160	Yan	Tigorev	Aleksandrovich	1984-03-10	Ussuriysk	6	26	Reserve	Midfielder	Belarus	182	74
161	Sergey	Tkachev	Anatolevich	1989-05-19	\N	6	77	Main	Midfielder	Rossiya	183	77
162	Maykon Markes	Bitenkurt	\N	1990-02-18	Duki-di-Kashias	6	7	Main	Forward	Braziliya	182	77
163	Roman	Pavlyuchenko	Anatolevich	1981-12-15	\N	6	9	Reserve	Forward	Rossiya	188	84
164	Umar	Niasse	\N	1990-04-18	Dakar	6	21	Reserve	Forward	Senegal	182	82
166	Anton	Kochenkov	Aleksandrovich	1987-04-02	\N	7	1	Main	Keeper	Rossiya	194	90
167	Viktor	Vasin	Vladimirovich	1988-10-06	\N	7	5	Main	Back	Rossiya	192	80
168	Marko	Lomich	\N	1983-09-13	Chachak	7	32	Main	Back	Serbiya	188	83
169	Ruslan	Nahushev	Yurevich	1984-09-05	Nalchik	7	55	Main	Back	Rossiya	184	80
170	Milan	Perendia	\N	1986-01-05	Belgrad	7	40	Main	Back	Serbiya	190	88
171	Igor	Shitov	Sergeevich	1986-10-24	\N	7	4	Main	Back	Belarus	186	81
172	Aslan	Dudiev	Muratovich	1990-06-15	\N	7	17	Main	Back	Rossiya	180	72
173	Vladimir	Bojovich	\N	1981-11-13	Pech	7	12	Main	Back	Chernogoriya	182	79
174	Oleg	Vlasov	Sergeevich	1984-12-10	\N	7	84	Main	Midfielder	Rossiya	177	73
175	Mitchell	Donald	\N	1988-12-10	Amsterdam	7	6	Main	Midfielder	Surinam	183	75
176	Richard Danilo	Souza Kampos	\N	1990-01-13	\N	7	10	Main	Midfielder	Belgiya	172	68
177	Dmitriy	Syisuev	Mihaylovich	1988-01-13	Saransk	7	11	Main	Midfielder	Rossiya	176	75
178	Anton	Bober	Anatolevich	1982-09-28	\N	7	8	Reserve	Midfielder	Rossiya	182	75
179	Aleksey	Ivanov	Vladimirovich	1981-09-01	Saratov	7	88	Reserve	Midfielder	Rossiya	175	65
180	Pavel	Ignatovich	Gennadevich	1989-05-24	Sankt-Peterburg	7	99	Reserve	Midfielder	Rossiya	178	71
181	Rustem	Muhametshin	Nailevich	1984-04-02	\N	7	9	Reserve	Midfielder	Rossiya	182	81
182	Lorentso	Ebesilio	\N	1991-09-24	\N	7	91	Other	Midfielder	Niderlandyi	189	80
183	Damen	Le Tallek	\N	1990-10-14	\N	7	7	Main	Forward	Frantsiya	185	75
184	Evgeniy	Lutsenko	Olegovich	1987-02-25	\N	7	48	Reserve	Forward	Rossiya	187	84
185	Ruslan	Muhametshin	Nailevich	1981-10-29	\N	7	23	Main	Forward	Rossiya	178	75
186	Mihail	Markin	Mihaylovich	1993-11-21	\N	7	13	Main	Forward	Rossiya	180	75
187	Denis	Shebanov	Olegovich	1989-11-27	\N	7	33	Reserve	Keeper	Rossiya	183	79
188	Stipe	Pletikosa	\N	1979-01-08	Split	8	1	Main	Keeper	Horvatiya	193	83
189	Vitaliy	Dyakov	Aleksandrovich	1989-01-31	\N	8	5	Main	Back	Rossiya	192	88
190	Bartolomeu Jasintu	Kissanga	\N	1991-03-27	\N	8	77	Main	Back	Angola	188	80
191	Hrvoye	Milich	\N	1989-05-10	\N	8	19	Main	Back	Horvatiya	183	74
192	Redjinal	Gore	\N	1987-12-31	\N	8	20	Main	Back	Gaiti	177	72
193	Maksim	Bordachev	Aleksandrovich	1986-06-18	\N	8	15	Main	Back	Belarus	190	83
194	Siyanda	Ksulu	\N	1991-12-30	Durban	8	55	Reserve	Back	YuAR	188	76
195	Ruslan	Abazov	Aslanovich	1993-05-25	\N	8	3	Other	Back	Rossiya	185	77
220	Igor	Lolo	\N	1982-07-22	\N	8	27	Reserve	Back	Kot-d-Ivuar	179	76
221	Timofey	Kalachev	Sergeevich	1981-05-01	\N	8	2	Main	Midfielder	Belarus	173	69
222	Dmitriy	Torbinskiy	\N	1984-04-28	Norilsk	8	4	Main	Midfielder	Rossiya	176	66
223	Aleksandr	Gatskan	Mihaylovich	1984-03-27	\N	8	84	Main	Midfielder	Moldova	186	79
224	Maksim	Grigorev	Sergeevich	1990-07-06	\N	8	7	Main	Midfielder	Rossiya	187	75
225	Mussa	Dumbiya	\N	1994-08-15	\N	8	8	Main	Midfielder	Mali	173	68
226	Azim	Fatullaev	Ikzamudinovich	1986-05-07	\N	8	18	Reserve	Midfielder	Rossiya	180	76
227	Kaku Guelor	Kanga	\N	1990-09-01	\N	8	9	Reserve	Midfielder	Gabon	167	63
228	Aleksey	Rebko	Vasilevich	1986-04-23	Moskva	8	6	Other	Midfielder	Rossiya	187	83
229	Aleksandr	Troshechkin	Igorevich	1996-04-23	Moskva	8	23	Other	Midfielder	Rossiya	183	78
230	Nika	Chhapeliya	Igorevich	1994-04-26	\N	8	17	Reserve	Midfielder	Rossiya	165	63
231	Dmitriy	Poloz	Dmitrievich	1991-07-12	\N	8	14	Main	Forward	Rossiya	183	73
232	Aleksandr	Buharov	Evgenevich	1985-03-12	Naberejnyie	8	11	Main	Forward	Rossiya	193	92
233	Sergey	Ryijikov	Viktorovich	1980-09-19	Shebekino	9	1	Main	Keeper	Rossiya	192	92
234	Solomon	Kverkveliya	\N	1992-02-06	Samtredia	9	5	Main	Back	Gruziya	190	75
235	Oleg	Kuzmin	Aleksandrovich	1981-05-09	Moskva	9	2	Main	Back	Rossiya	175	72
236	Sesar	Navas	Ramilevich	1980-02-14	Mostoles	9	44	Main	Back	Ispaniya	197	83
237	Mamuka	Kobahidze	\N	1992-08-23	\N	9	23	Main	Back	Gruziya	189	79
238	Egor	Sorokin	Andreevich	1995-11-04	\N	9	80	Other	Back	Rossiya	189	81
239	Magomed	Ozdoev	Mustafaevich	1992-11-05	\N	9	27	Main	Midfielder	Rossiya	181	77
240	Gekdeniz	Karadeniz	\N	1980-01-11	Giresun	9	61	Main	Midfielder	Turtsiya	168	68
241	Karlos	Eduardo	\N	1987-07-18	Ajurikaba	9	87	Main	Midfielder	Braziliya	171	68
242	Ruslan	Kambolov	Aleksandrovich	1990-01-01	Vladikavkaz	9	88	Main	Midfielder	Rossiya	182	73
243	Sergey	Kislyak	Viktorovich	1987-08-06	Kamenets	9	15	Reserve	Midfielder	Belarus	180	75
244	Ilzat	Ahmetov	Toglokovich	1997-12-31	\N	9	85	Other	Midfielder	Rossiya	172	65
245	Maksim	Kanunnikov	Sergeevich	1991-07-14	Nijniy	9	99	Main	Forward	Rossiya	184	77
246	Igor	Portnyagin	Igorevich	1989-01-07	Vladivostok	9	7	Main	Forward	Rossiya	190	75
247	Serdar	Azmun	\N	1995-01-01	\N	9	69	Reserve	Forward	Iran	178	72
248	Vladimir	Dyadyun	Sergeevich	1988-07-12	Omsk	9	8	Main	Forward	Rossiya	183	77
249	Marko	Livayya	\N	1993-08-26	Split	9	10	Main	Forward	Horvatiya	182	81
250	Marko	Devich	\N	1983-10-27	Belgrad	9	11	Other	Forward	Serbiya	185	76
251	Taras	Burlak	Aleksandrovich	1990-02-22	Vladivostok	9	4	Reserve	Back	Rossiya	187	78
252	Artem	Rebrov	Gennadevich	1984-03-04	\N	10	32	Main	Keeper	Rossiya	193	88
253	Sergey	Parshivlyuk	Viktorovich	1989-03-18	Moskva	10	4	Main	Back	Rossiya	180	75
254	Evgeniy	Makeev	Vladimirovich	1989-07-24	Cherepovets	10	34	Main	Back	Rossiya	181	73
255	Huan Manuel	Insaurralde	\N	1984-10-03	\N	10	2	Main	Back	Argentina	187	84
256	Serdar	Taski	\N	1987-04-24	Esslingen	10	35	Reserve	Back	Germaniya	186	80
257	Joao	Karlos	\N	1982-01-01	Realengo	10	55	Main	Back	Braziliya	189	80
258	Sergey	Bryizgalov	Vladimirovich	1992-11-15	Pavlovo	10	3	Reserve	Back	Rossiya	178	72
259	Salvatore	Bokketti	\N	1986-11-30	Neapol	10	33	Reserve	Back	Italiya	186	81
260	Denis	Kutin	Sergeevich	1993-10-05	Gamburg	10	64	Other	Back	Rossiya	187	70
261	Kim	Chelstrem	\N	1982-08-24	Sandviken	10	21	Main	Midfielder	Shvetsiya	181	79
262	Denis	Glushakov	Borisovich	1987-01-27	Millerovo	10	8	Main	Midfielder	Rossiya	182	80
263	Romulo	Borges Monteyro	\N	1990-09-19	Pikos	10	15	Main	Midfielder	Braziliya	187	82
264	Djano	Ananidze	\N	1992-10-10	Kobuleti	10	7	Reserve	Midfielder	Gruziya	173	61
265	Tino	Kosta	\N	1985-01-09	Buenos-Ayres	10	5	Reserve	Midfielder	Argentina	176	75
266	Patrik	Ebert	\N	1987-03-17	Potsdam	10	20	Main	Midfielder	Germaniya	176	76
267	Roman	Shirokov	Nikolaevich	1981-07-06	Dedovsk	10	9	Main	Midfielder	Rossiya	187	83
268	Aleksandr	Zuev	Dmitrievich	1996-06-26	\N	10	87	Other	Midfielder	Rossiya	175	62
269	Kvinsi	Promes	\N	1992-01-04	\N	10	24	Main	Forward	Niderlandyi	174	70
270	Artem	Dzyuba	Sergeevich	1988-08-22	Moskva	10	22	Main	Forward	Rossiya	196	89
271	Pavel	Yakovlev	Vladimirovich	1991-04-07	\N	10	14	Main	Forward	Rossiya	180	72
272	Dmitriy	Kombarov	Vladimirovich	1987-01-22	Moskva	10	23	Main	Back	Rossiya	181	86
274	Yaroslav	Godzyur	\N	1985-03-06	\N	11	1	Main	Keeper	Rossiya	194	88
275	Martsin	Komorovski	\N	1984-04-17	\N	11	24	Main	Back	Polsha	186	75
276	Rizvan	Utsiev	Rashitovich	1988-02-07	\N	11	40	Main	Back	Rossiya	173	68
277	Fedor	Kudryashov	Vasilevich	1987-04-05	Mamakan	11	13	Main	Back	Rossiya	184	78
278	Andrey	Semenov	Sergeevich	1989-03-24	Moskva	11	15	Main	Back	Rossiya	190	86
279	Yuhani	Oyala	\N	1989-06-19	Vantaa	11	4	Main	Back	Finlyandiya	191	83
280	Antonio	Ferreyra	\N	1984-10-24	\N	11	5	Reserve	Back	Braziliya	191	83
281	Da Silveyra	Maurisio Joze	Djunior	1988-10-21	\N	11	8	Main	Midfielder	Braziliya	180	72
282	Igor	Lebedenko	Vladimirovich	1983-05-27	\N	11	55	Main	Midfielder	Rossiya	182	78
283	Oleg	Ivanov	Aleksandrovich	1986-08-04	Moskva	11	19	Main	Midfielder	Rossiya	192	82
284	Matsey	Ryibus	\N	1989-08-19	Lovich	11	31	Main	Midfielder	Polsha	172	75
285	Adilson	Varken	\N	1987-01-16	\N	11	6	Main	Midfielder	Braziliya	181	75
286	Ismail	Ayssati	\N	1988-08-16	\N	11	14	Reserve	Midfielder	Marokko	174	70
287	Rubenilson	da Rocha	dos	1987-09-23	\N	11	10	Reserve	Midfielder	Braziliya	190	85
288	Daler	Kuzyaev	Adyamovich	1993-01-15	\N	11	21	Main	Midfielder	Rossiya	177	68
289	Fakundo	Piris	\N	1990-03-27	\N	11	23	Reserve	Midfielder	Urugvay	186	75
290	Halid	Kadyirov	Hoj-Baudievich	1994-04-19	\N	11	7	Main	Midfielder	Rossiya	164	56
291	Ailton	Almeyda	\N	1984-08-20	\N	11	9	Main	Forward	Braziliya	180	76
292	Loteteka	Bokila	\N	1988-11-14	\N	11	18	Main	Forward	DR_Kongo	189	78
293	Yuriy	Jevnov	Vladimirovich	1981-04-17	Dobrush	12	30	Main	Keeper	Belarus	180	85
294	Aleksandr	Budakov	Vladimirovich	1985-02-10	\N	12	98	Reserve	Keeper	Rossiya	185	84
295	Adam	Kokoshka	\N	1986-10-06	\N	12	3	Main	Back	Polsha	186	92
296	Vladimir	Ryikov	Vladimirovich	1987-11-13	\N	12	33	Main	Back	Rossiya	191	83
297	Ivan	Novoseltsev	Evgenevich	1991-08-25	\N	12	25	Main	Back	Rossiya	190	80
298	Aleksandr	Katsalapov	Anatolevich	1986-04-05	\N	12	34	Main	Back	Rossiya	185	78
299	Kirill	Kombarov	Vladimirovich	1987-01-22	Moskva	12	9	Main	Back	Rossiya	181	73
300	Mihail	Bagaev	Nikolaevich	1985-02-28	\N	12	17	Main	Back	Rossiya	179	76
301	Egor	Tarakanov	Sergeevich	1987-04-17	\N	12	15	Other	Back	Rossiya	185	78
302	Ivan	Franich	\N	1987-09-10	Melburn	12	8	Other	Back	Avstraliya	180	77
303	Ivan	Knyazev	Evgenevich	1992-11-05	\N	12	5	Main	Back	Rossiya	188	82
304	Reziuan	Mirzov	Muhamedovich	1993-06-22	\N	12	11	Main	Midfielder	Rossiya	179	75
305	Dalibor	Stevanovich	\N	1984-09-27	Lyublyana	12	16	Main	Midfielder	Sloveniya	183	75
306	Semen	Fomin	Anatolevich	1989-01-10	Vladivostok	12	7	Main	Midfielder	Rossiya	180	79
307	Aleksandr	Salugin	Sergeevich	1988-10-23	\N	12	77	Main	Midfielder	Rossiya	185	75
308	Aleksey	Pugin	Anatolevich	1987-03-07	\N	12	18	Reserve	Midfielder	Rossiya	182	75
309	Diniyar	Bilyaletdinov	Rinatovich	1985-02-27	Moskva	12	23	Main	Midfielder	Rossiya	185	77
310	Anton	Putilo	\N	1987-06-23	\N	12	14	Main	Midfielder	Belarus	180	74
311	Vadim	Steklov	Aleksandrovich	1987-03-24	\N	12	20	Main	Midfielder	Rossiya	171	71
312	Yuriy	Kuleshov	Vladimirovich	1981-04-12	\N	12	40	Reserve	Midfielder	Rossiya	176	75
313	Igor	Shevchenko	Vladimirovich	1985-02-02	Samara	12	88	Reserve	Forward	Rossiya	181	74
314	Sergey	Davyidov	Sergeevich	1985-07-22	Moskva	12	10	Reserve	Forward	Rossiya	188	85
315	Ugu Filipe	da Koshta Vieyra	\N	1988-07-25	Barselush	12	27	Main	Forward	Portugaliya	178	73
316	Nikolay	Zabolotnyiy	Archilovich	1990-04-16	Sankt-Peterburg	13	28	Main	Keeper	Rossiya	184	81
317	Vladimir	Hozin	Vyacheslavovich	1989-07-03	\N	13	2	Main	Back	Rossiya	185	80
318	Aleksandr	Dantsev	Alekseevich	1984-10-14	Kamensk	13	7	Main	Back	Rossiya	178	74
319	Solvi	Ottesen	\N	1984-02-18	Reyk'yavik	13	6	Main	Back	Islandiya	189	77
320	Pablo	Fontanelo	\N	1984-09-26	Linkoln	13	29	Main	Back	Argentina	193	84
321	Markus	Berger	\N	1985-01-21	Zaltsburg	13	4	Main	Back	Avstriya	186	82
322	Aleksandr	Erohin	Yurevich	1989-10-13	Barnaul	13	89	Main	Midfielder	Rossiya	193	82
323	Artem	Fidler	Igorevich	1983-07-14	Ekaterinburg	13	57	Reserve	Midfielder	Rossiya	178	74
324	Gerson	Asevedo	\N	1988-04-05	Santyago	13	21	Main	Midfielder	Chili	184	83
325	Konstantin	Yaroshenko	Yurevich	1986-09-12	\N	13	99	Main	Midfielder	Ukraina	176	62
326	Aleksandr	Stavpets	Aleksandrovich	1989-07-04	Orel	13	25	Main	Midfielder	Rossiya	179	74
327	Aleksandr	Sapeta	Sergeevich	1989-06-28	\N	13	41	Main	Midfielder	Rossiya	183	79
328	Vyacheslav	Podberezkin	Mihaylovich	1992-06-21	\N	13	14	Main	Midfielder	Rossiya	187	76
329	Arsen	Oganesyan	Grigorevich	1990-06-17	\N	13	15	Other	Midfielder	Rossiya	183	74
330	Aleksandr	Novikov	Aleksandrovich	1984-10-12	\N	13	12	Main	Midfielder	Rossiya	185	78
331	Roman	Emelyanov	Pavlovich	1992-05-08	\N	13	5	Main	Midfielder	Rossiya	189	85
332	Aleksandr	Schanitsin	Evgenevich	1984-12-02	\N	13	11	Reserve	Midfielder	Rossiya	173	72
333	Chisamba	Lungu	\N	1991-01-31	\N	13	3	Reserve	Forward	Zambiya	178	68
334	Edgar	Manucharyan	Vagrikovich	1987-01-19	Erevan	13	10	Main	Forward	Armeniya	177	72
335	Spartak	Gogniev	Arturovich	1981-01-19	\N	13	9	Main	Forward	Rossiya	185	79
336	Fedor	Smolov	Mihaylovich	1990-02-09	Saratov	13	90	Main	Forward	Rossiya	187	80
337	Denis	Dorojkin	Igorevich	1987-06-08	\N	13	34	Reserve	Forward	Rossiya	191	82
338	Georgiy	Nurov	Valerevich	1992-06-08	\N	13	18	Other	Forward	Rossiya	178	74
339	David	Yurchenko	Viktorovich	1986-03-27	\N	14	1	Main	Keeper	Rossiya	186	80
340	Sergey	Veremko	Nikolaevich	1982-10-16	Minsk	14	16	Reserve	Keeper	Belarus	190	90
341	Maksim	Tishkin	Viktorovich	1989-11-11	\N	14	31	Main	Back	Rossiya	181	70
342	Aleksandr	Suhov	Aleksandrovich	1986-01-03	\N	14	15	Main	Back	Rossiya	174	71
343	Denis	Tumasyan	Aleksandrovich	1985-04-24	\N	14	20	Main	Back	Rossiya	185	82
344	Pavel	Alikin	Pavlovich	1984-03-06	\N	14	3	Main	Back	Rossiya	186	79
346	Felisio Anando	Braun Forbs	\N	1991-08-28	Berlin	14	28	Other	Back	Germaniya	189	81
347	Pavel	Stepanets	Nikolaevich	1987-05-26	Gorodnya	14	4	Other	Back	Ukraina	185	80
348	Dmitriy	Verhovtsov	Nikolaevich	1986-10-10	\N	14	81	Main	Back	Belarus	189	86
349	Ivan	Paurevich	\N	1991-07-01	Essen	14	19	Main	Midfielder	Horvatiya	194	86
350	Marsio de Souza	Gregori Junior	\N	1986-05-14	Volta-Redonda	14	10	Reserve	Midfielder	Braziliya	182	79
351	Azamat	Zaseev	Vyacheslavovich	1988-04-29	\N	14	13	Main	Midfielder	Rossiya	179	69
352	Vagiz	Galiulin	Iskanderovich	1987-10-10	\N	14	22	Main	Midfielder	Uzbekistan	175	66
353	Maksim	Semakin	Valerevich	1983-10-26	\N	14	14	Main	Midfielder	Rossiya	180	75
354	Nikolay	Safronidi	Afanasevich	1983-09-10	\N	14	70	Main	Midfielder	Rossiya	180	72
355	Emmanuel	Frimpong	\N	1992-01-10	Akkra	14	5	Main	Midfielder	Gana	178	90
356	Nikita	Bezlihotnov	Sergeevich	1990-08-19	\N	14	7	Reserve	Midfielder	Rossiya	177	70
357	Takafumi	Akahoshi	\N	1986-05-27	Fudji	14	27	Other	Midfielder	Yaponiya	175	66
358	Haris	Handjich	\N	1990-06-20	Saraevo	14	9	Main	Forward	Bosniya_i_Gertsegovina	191	85
359	Diego	Karlos	\N	1988-05-15	\N	14	11	Reserve	Forward	Braziliya	174	67
360	Aleksandr	Vasilev	Nikolaevich	1992-01-23	\N	14	49	Reserve	Forward	Rossiya	185	75
361	Dmitriy	Golubov	Sergeevich	1985-06-24	\N	14	18	Main	Forward	Rossiya	178	71
362	Igor	Akinfeev	Vladimirovich	1986-04-08	\N	15	35	Main	Keeper	Rossiya	185	71
363	Mario	Fernandes	\N	1990-09-19	\N	15	2	Main	Back	Braziliya	188	81
364	Sergey	Ignashevich	Nikolaevich	1979-07-14	\N	15	4	Main	Back	Rossiya	186	75
365	Vasiliy	Berezutskiy	Vladimirovich	1982-06-20	\N	15	24	Main	Back	Rossiya	189	83
366	Georgiy	Schennikov	Mihaylovich	1991-04-27	\N	15	42	Main	Back	Rossiya	178	69
367	Kirill	Nababkin	Anatolevich	1986-09-08	\N	15	14	Reserve	Back	Rossiya	184	74
368	Aleksey	Berezutskiy	Vladimirovich	1982-06-20	\N	15	6	Reserve	Back	Rossiya	190	82
369	Zoran	Toshich	\N	1987-04-28	\N	15	7	Main	Midfielder	Serbiya	171	70
370	Georgi	Milanov	\N	1992-02-19	Levski	15	23	Main	Midfielder	Bolgariya	184	73
371	Pontus	Vernblum	\N	1986-06-25	Kungelv	15	3	Main	Midfielder	Shvetsiya	187	85
372	Alan	Dzagoev	Elizbarovich	1990-06-17	Beslan	15	10	Main	Midfielder	Rossiya	179	70
373	Bibras	Natho	\N	1988-02-18	Kfar	15	66	Main	Midfielder	Izrail	175	73
374	Roman	Eremenko	Alekseevich	1987-03-19	Moskva	15	25	Main	Midfielder	Finlyandiya	180	67
375	Dmitriy	Efremov	Vladislavovich	1995-04-01	\N	15	15	Main	Midfielder	Rossiya	180	70
376	Aleksandr	Tsaunya	\N	1988-01-19	Daugavpils	15	19	Main	Midfielder	Latviya	174	66
377	Ahmed	Musa	\N	1992-10-14	\N	15	18	Main	Forward	Nigeriya	170	62
378	Seydu	Dumbiya	\N	1987-12-31	\N	15	88	Main	Forward	Kot-d-Ivuar	178	72
379	Kirill	Panchenko	Viktorovich	1989-10-16	\N	15	11	Reserve	Forward	Rossiya	185	83
380	Viktor Vinisius	Koelo dos Santos	\N	1993-10-09	\N	15	31	Reserve	Forward	Braziliya	184	73
381	Konstantin	Bazelyuk	Sergeevich	1993-04-12	\N	15	71	Reserve	Forward	Rossiya	187	78
\.


--
-- Name: players_player_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('players_player_id_seq', 1, false);


--
-- Data for Name: stadium; Type: TABLE DATA; Schema: public; Owner: -
--

COPY stadium (stadium_id, name, address, capacity, stadium_coverage, opened) FROM stdin;
1	Petrovskiy	Sankt-Peterburg	21504	Natural	1925
2	Kazan-Arena	Kazan	45105	Synthetic	2013
3	Otkryitie-Arena	Moskva	45000	Synthetic	2014
4	Metallurg	Samara	33001	Natural	1957
5	Kuban	Krasnodar	31654	Natural	1960
6	Ahmat-Arena	Groznyiy	30597	Synthetic	2011
7	Anji-Arena	Kaspiysk	30000	Synthetic	2003
8	Lokomotiv	Moskva	28800	Natural	2002
9	Tsentralnyiy	Ekaterinburg	27000	Natural	1957
10	Arena-Himki	Himki	18636	Synthetic	2008
11	Zvezda	Perm	17000	Natural	1969
12	Olimp-2	Rostov-na-Donu	15840	Natural	1930
13	Saturn	Ramenskoe	16500	Natural	1999
14	Dinamo	Ufa	4500	Natural	1972
15	Start	Saransk	11581	Natural	2004
16	TsS Arsenal	Tula	20048	Natural	1959
\.


--
-- Name: stadium_stadium_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('stadium_stadium_id_seq', 1, false);


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: -
--

COPY team (team_id, name, coach, city, stadium_id) FROM stdin;
1	Amkar	Slavolyub Muslin	Perm	11
2	Arsenal T	Dmitriy Alenichev	Tula	16
3	Dinamo M	Stanislav Cherchesov	Moskva	10
4	Zenit	Andre Villash-Boash	Sankt-Peterburg	1
5	Krasnodar	Oleg Kononov	Krasnodar	5
6	Lokomotiv	Miodrag Bojovich	Moskva	8
7	Mordoviya	Yuriy Semin	Saransk	15
8	Rostov	Igor Gamula	Rostov-na-Donu	12
9	Rubin	Valeriy Chalyiy	Kazan	2
10	Spartak	Murat Yakin	Moskva	3
11	Terek	Rashid Rahimov	Groznyiy	6
12	Torpedo	Valeriy Petrakov	Moskva	13
13	Ural	Aleksandr Tarhanov	Ekaterinburg	9
14	Ufa	Igor Kolyivanov	Ufa	14
15	TsSKA	Leonid Slutskiy	Moskva	10
16	Kuban	Leonid Kuchuk	Krasnodar	5
\.


--
-- Name: team_team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('team_team_id_seq', 1, false);


--
-- Data for Name: trauma; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trauma (trauma_id, match_id, player_id, moment, description) FROM stdin;
\.


--
-- Name: trauma_trauma_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('trauma_trauma_id_seq', 1, false);


--
-- Data for Name: warnings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY warnings (warning_id, match_id, player_id, moment, type) FROM stdin;
1	1	265	89	Yellow
2	1	253	84	Yellow
3	1	255	64	Yellow
4	2	169	90	Yellow
5	2	171	84	Yellow
6	2	176	54	Yellow
7	3	84	53	Yellow
8	3	39	49	Yellow
9	4	363	75	Yellow
10	4	306	55	Yellow
11	4	313	43	Yellow
12	4	296	33	Red
13	5	60	85	Yellow
14	5	56	49	Yellow
15	5	226	40	Yellow
16	5	221	20	Yellow
17	5	188	14	Yellow
18	6	125	90	Yellow
19	6	347	90	Yellow
20	6	131	77	Yellow
21	6	128	45	Yellow
22	6	341	25	Yellow
23	6	347	14	Yellow
24	7	152	90	Yellow
25	7	100	67	Yellow
26	7	149	59	Yellow
27	7	106	44	Yellow
28	7	\N	30	Yellow
29	7	150	25	Yellow
30	8	285	71	Yellow
31	8	19	67	Yellow
32	8	3	58	Yellow
33	9	350	86	Yellow
34	9	4	50	Yellow
35	9	341	38	Yellow
36	10	221	64	Yellow
37	10	190	63	Yellow
38	10	232	63	Yellow
39	10	195	47	Yellow
40	10	123	27	Yellow
41	11	175	60	Yellow
42	11	371	56	Yellow
43	11	171	49	Yellow
44	11	380	47	Yellow
45	11	378	26	Yellow
46	12	307	82	Yellow
47	12	\N	71	Yellow
48	12	92	45	Yellow
49	12	76	40	Yellow
50	12	92	19	Yellow
51	13	283	66	Yellow
52	13	285	41	Yellow
53	13	250	41	Yellow
54	13	284	29	Yellow
55	14	54	90	Yellow
56	14	252	86	Yellow
57	14	261	73	Yellow
58	14	270	45	Yellow
59	14	64	26	Yellow
60	14	265	26	Yellow
61	15	101	84	Yellow
62	15	319	79	Yellow
63	15	108	54	Yellow
64	15	323	35	Yellow
65	16	40	57	Yellow
66	16	148	41	Yellow
67	16	35	38	Yellow
68	16	146	36	Yellow
69	17	5	90	Yellow
70	17	13	82	Yellow
71	17	296	81	Yellow
72	17	14	78	Yellow
73	17	307	59	Yellow
74	17	9	32	Yellow
75	19	327	90	Yellow
76	19	322	89	Yellow
77	19	75	51	Yellow
78	20	\N	90	Yellow
79	20	239	90	Yellow
80	20	235	85	Yellow
81	20	49	74	Yellow
82	20	233	74	Yellow
83	20	240	33	Yellow
84	20	234	27	Yellow
92	21	285	54	Yellow
93	21	277	50	Yellow
94	21	371	48	Yellow
95	21	364	45	Yellow
96	21	278	44	Yellow
97	21	283	36	Yellow
98	21	276	27	Yellow
105	22	192	90	Yellow
106	22	163	88	Yellow
107	22	148	70	Red
108	22	159	45	Yellow
109	22	221	45	Red
110	23	253	79	Yellow
111	23	259	73	Yellow
112	23	111	62	Yellow
113	23	254	59	Yellow
114	24	141	69	Red
115	24	171	69	Yellow
\.


--
-- Name: warnings_warning_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('warnings_warning_id_seq', 1, false);


--
-- Name: assists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assists
    ADD CONSTRAINT assists_pkey PRIMARY KEY (assist_id);


--
-- Name: championship_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY championship
    ADD CONSTRAINT championship_name_key UNIQUE (name);


--
-- Name: championship_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY championship
    ADD CONSTRAINT championship_pkey PRIMARY KEY (championship_id);


--
-- Name: goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (goal_id);


--
-- Name: judge_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY judge
    ADD CONSTRAINT judge_pkey PRIMARY KEY (judge_id);


--
-- Name: matchs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY matchs
    ADD CONSTRAINT matchs_pkey PRIMARY KEY (match_id);


--
-- Name: players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT players_pkey PRIMARY KEY (player_id);


--
-- Name: stadium_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stadium
    ADD CONSTRAINT stadium_pkey PRIMARY KEY (stadium_id);


--
-- Name: team_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_name_key UNIQUE (name);


--
-- Name: team_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_pkey PRIMARY KEY (team_id);


--
-- Name: trauma_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trauma
    ADD CONSTRAINT trauma_pkey PRIMARY KEY (trauma_id);


--
-- Name: warnings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY warnings
    ADD CONSTRAINT warnings_pkey PRIMARY KEY (warning_id);


--
-- Name: assists_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assists
    ADD CONSTRAINT assists_match_id_fkey FOREIGN KEY (match_id) REFERENCES matchs(match_id);


--
-- Name: assists_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY assists
    ADD CONSTRAINT assists_player_id_fkey FOREIGN KEY (player_id) REFERENCES players(player_id);


--
-- Name: goals_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_match_id_fkey FOREIGN KEY (match_id) REFERENCES matchs(match_id);


--
-- Name: goals_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_player_id_fkey FOREIGN KEY (player_id) REFERENCES players(player_id);


--
-- Name: matchs_guest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY matchs
    ADD CONSTRAINT matchs_guest_id_fkey FOREIGN KEY (guest_id) REFERENCES team(team_id);


--
-- Name: matchs_judge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY matchs
    ADD CONSTRAINT matchs_judge_id_fkey FOREIGN KEY (judge_id) REFERENCES judge(judge_id);


--
-- Name: matchs_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY matchs
    ADD CONSTRAINT matchs_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES team(team_id);


--
-- Name: matchs_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY matchs
    ADD CONSTRAINT matchs_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES stadium(stadium_id);


--
-- Name: matchs_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY matchs
    ADD CONSTRAINT matchs_status_id_fkey FOREIGN KEY (status_id) REFERENCES championship(championship_id);


--
-- Name: players_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY players
    ADD CONSTRAINT players_team_id_fkey FOREIGN KEY (team_id) REFERENCES team(team_id);


--
-- Name: team_stadium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_stadium_id_fkey FOREIGN KEY (stadium_id) REFERENCES stadium(stadium_id);


--
-- Name: trauma_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trauma
    ADD CONSTRAINT trauma_match_id_fkey FOREIGN KEY (match_id) REFERENCES matchs(match_id);


--
-- Name: trauma_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trauma
    ADD CONSTRAINT trauma_player_id_fkey FOREIGN KEY (player_id) REFERENCES players(player_id);


--
-- Name: warnings_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY warnings
    ADD CONSTRAINT warnings_match_id_fkey FOREIGN KEY (match_id) REFERENCES matchs(match_id);


--
-- Name: warnings_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY warnings
    ADD CONSTRAINT warnings_player_id_fkey FOREIGN KEY (player_id) REFERENCES players(player_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
