--
-- PostgreSQL database dump
--

\restrict XPRmvivb2O1tq9Lq9EXw17YFns69b8O8izSbKxnHc4Sn8Cf3xaYMZTETxXDVz7w

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-27 00:18:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 875 (class 1247 OID 33003)
-- Name: aff_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.aff_type AS ENUM (
    'BORN_IN',
    'BY_MARRIAGE',
    'SWORN',
    'HOSTAGE',
    'OTHER'
);


ALTER TYPE public.aff_type OWNER TO postgres;

--
-- TOC entry 887 (class 1247 OID 33046)
-- Name: event_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.event_type AS ENUM (
    'BATTLE',
    'WEDDING',
    'COUNCIL',
    'BETRAYAL',
    'CORONATION',
    'OTHER'
);


ALTER TYPE public.event_type OWNER TO postgres;

--
-- TOC entry 884 (class 1247 OID 33032)
-- Name: house_relation; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.house_relation AS ENUM (
    'ALLY',
    'ENEMY',
    'VASSAL',
    'LIEGE',
    'NEUTRAL',
    'OTHER'
);


ALTER TYPE public.house_relation OWNER TO postgres;

--
-- TOC entry 881 (class 1247 OID 33024)
-- Name: life_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.life_status AS ENUM (
    'ALIVE',
    'DEAD',
    'UNKNOWN'
);


ALTER TYPE public.life_status OWNER TO postgres;

--
-- TOC entry 878 (class 1247 OID 33014)
-- Name: sex_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sex_type AS ENUM (
    'FEMALE',
    'MALE',
    'OTHER',
    'UNKNOWN'
);


ALTER TYPE public.sex_type OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 33319)
-- Name: trg_bannerman_parent_must_be_great(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trg_bannerman_parent_must_be_great() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE parent_is_great boolean;
BEGIN
  IF NEW.parent_id IS NULL THEN
    RETURN NEW;
  END IF;

  SELECT is_great INTO parent_is_great FROM houses WHERE id = NEW.parent_id;

  IF parent_is_great IS DISTINCT FROM TRUE THEN
    RAISE EXCEPTION 'parent_id must reference a great house';
  END IF;

  IF NEW.is_great = TRUE AND NEW.parent_id IS NOT NULL THEN
    RAISE EXCEPTION 'great house cannot have parent';
  END IF;

  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trg_bannerman_parent_must_be_great() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 238 (class 1259 OID 33289)
-- Name: event_houses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_houses (
    event_id integer NOT NULL,
    house_id integer NOT NULL,
    role character varying(80)
);


ALTER TABLE public.event_houses OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 33272)
-- Name: event_persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_persons (
    event_id integer NOT NULL,
    person_id integer NOT NULL,
    role character varying(80),
    side character varying(80)
);


ALTER TABLE public.event_persons OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 33258)
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    type public.event_type DEFAULT 'OTHER'::public.event_type NOT NULL,
    year integer,
    location character varying(200),
    description text
);


ALTER TABLE public.events OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 33257)
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO postgres;

--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 235
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- TOC entry 234 (class 1259 OID 33233)
-- Name: house_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.house_relations (
    id integer NOT NULL,
    from_house_id integer NOT NULL,
    to_house_id integer NOT NULL,
    type public.house_relation NOT NULL,
    start_year integer,
    end_year integer,
    note text,
    CONSTRAINT house_relations_check CHECK ((from_house_id <> to_house_id)),
    CONSTRAINT house_relations_check1 CHECK (((end_year IS NULL) OR (start_year IS NULL) OR (end_year >= start_year)))
);


ALTER TABLE public.house_relations OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 33232)
-- Name: house_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.house_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.house_relations_id_seq OWNER TO postgres;

--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 233
-- Name: house_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.house_relations_id_seq OWNED BY public.house_relations.id;


--
-- TOC entry 222 (class 1259 OID 33071)
-- Name: houses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.houses (
    id integer NOT NULL,
    name character varying(120) NOT NULL,
    region_id integer,
    is_great boolean DEFAULT false NOT NULL,
    parent_id integer,
    seat character varying(120),
    words character varying(200),
    sigil_url text,
    description text
);


ALTER TABLE public.houses OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 33070)
-- Name: houses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.houses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.houses_id_seq OWNER TO postgres;

--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 221
-- Name: houses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.houses_id_seq OWNED BY public.houses.id;


--
-- TOC entry 229 (class 1259 OID 33175)
-- Name: marriages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marriages (
    id integer NOT NULL,
    spouse1_id integer NOT NULL,
    spouse2_id integer NOT NULL,
    start_year integer,
    end_year integer,
    note text,
    CONSTRAINT marriages_check CHECK ((spouse1_id <> spouse2_id)),
    CONSTRAINT marriages_check1 CHECK (((end_year IS NULL) OR (start_year IS NULL) OR (end_year >= start_year)))
);


ALTER TABLE public.marriages OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 33174)
-- Name: marriages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.marriages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.marriages_id_seq OWNER TO postgres;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 228
-- Name: marriages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.marriages_id_seq OWNED BY public.marriages.id;


--
-- TOC entry 227 (class 1259 OID 33153)
-- Name: parent_child; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parent_child (
    parent_id integer NOT NULL,
    child_id integer NOT NULL,
    relation character varying(30) DEFAULT 'BIOLOGICAL'::character varying NOT NULL,
    CONSTRAINT parent_child_check CHECK ((parent_id <> child_id))
);


ALTER TABLE public.parent_child OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33116)
-- Name: person_aliases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_aliases (
    person_id integer NOT NULL,
    alias character varying(120) NOT NULL
);


ALTER TABLE public.person_aliases OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33130)
-- Name: person_house_affiliations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_house_affiliations (
    person_id integer NOT NULL,
    house_id integer NOT NULL,
    type public.aff_type NOT NULL,
    start_year integer,
    end_year integer,
    note text,
    CONSTRAINT person_house_affiliations_check CHECK (((end_year IS NULL) OR (start_year IS NULL) OR (end_year >= start_year)))
);


ALTER TABLE public.person_house_affiliations OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 33210)
-- Name: person_titles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_titles (
    person_id integer NOT NULL,
    title_id integer NOT NULL,
    start_year integer NOT NULL,
    end_year integer,
    note text,
    CONSTRAINT person_titles_check CHECK (((end_year IS NULL) OR (start_year IS NULL) OR (end_year >= start_year)))
);


ALTER TABLE public.person_titles OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 33099)
-- Name: persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons (
    id integer NOT NULL,
    full_name character varying(120) NOT NULL,
    sex public.sex_type DEFAULT 'UNKNOWN'::public.sex_type NOT NULL,
    status public.life_status DEFAULT 'UNKNOWN'::public.life_status NOT NULL,
    born_year integer,
    died_year integer,
    description text,
    CONSTRAINT persons_check CHECK (((died_year IS NULL) OR (born_year IS NULL) OR (died_year >= born_year)))
);


ALTER TABLE public.persons OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 33098)
-- Name: persons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.persons_id_seq OWNER TO postgres;

--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 223
-- Name: persons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persons_id_seq OWNED BY public.persons.id;


--
-- TOC entry 220 (class 1259 OID 33060)
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 33059)
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_id_seq OWNER TO postgres;

--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 219
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- TOC entry 231 (class 1259 OID 33200)
-- Name: titles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.titles (
    id integer NOT NULL,
    name character varying(120) NOT NULL
);


ALTER TABLE public.titles OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 33199)
-- Name: titles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.titles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.titles_id_seq OWNER TO postgres;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 230
-- Name: titles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.titles_id_seq OWNED BY public.titles.id;


--
-- TOC entry 240 (class 1259 OID 33310)
-- Name: v_bannermen; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_bannermen AS
 SELECT b.id,
    b.name,
    g.name AS great_house
   FROM (public.houses b
     JOIN public.houses g ON ((g.id = b.parent_id)))
  WHERE (b.is_great = false);


ALTER VIEW public.v_bannermen OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 33306)
-- Name: v_great_houses; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_great_houses AS
 SELECT id,
    name,
    region_id,
    is_great,
    parent_id,
    seat,
    words,
    sigil_url,
    description
   FROM public.houses
  WHERE ((is_great = true) AND (parent_id IS NULL));


ALTER VIEW public.v_great_houses OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 33314)
-- Name: v_person_search; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_person_search AS
 SELECT persons.id,
    persons.full_name AS key_name,
    persons.full_name AS display_name
   FROM public.persons
UNION
 SELECT p.id,
    a.alias AS key_name,
    p.full_name AS display_name
   FROM (public.person_aliases a
     JOIN public.persons p ON ((p.id = a.person_id)));


ALTER VIEW public.v_person_search OWNER TO postgres;

--
-- TOC entry 4948 (class 2604 OID 33261)
-- Name: events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- TOC entry 4947 (class 2604 OID 33236)
-- Name: house_relations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.house_relations ALTER COLUMN id SET DEFAULT nextval('public.house_relations_id_seq'::regclass);


--
-- TOC entry 4939 (class 2604 OID 33074)
-- Name: houses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.houses ALTER COLUMN id SET DEFAULT nextval('public.houses_id_seq'::regclass);


--
-- TOC entry 4945 (class 2604 OID 33178)
-- Name: marriages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marriages ALTER COLUMN id SET DEFAULT nextval('public.marriages_id_seq'::regclass);


--
-- TOC entry 4941 (class 2604 OID 33102)
-- Name: persons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons ALTER COLUMN id SET DEFAULT nextval('public.persons_id_seq'::regclass);


--
-- TOC entry 4938 (class 2604 OID 33063)
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- TOC entry 4946 (class 2604 OID 33203)
-- Name: titles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.titles ALTER COLUMN id SET DEFAULT nextval('public.titles_id_seq'::regclass);


--
-- TOC entry 5191 (class 0 OID 33289)
-- Dependencies: 238
-- Data for Name: event_houses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_houses (event_id, house_id, role) FROM stdin;
1	1	victim_house
1	4	ruling_house
2	6	attacker
2	4	defender
3	1	victims
3	13	hosts
3	11	conspirators
4	6	royal_house
4	5	marriage_alliance
4	4	power_bloc
5	1	attacker
5	11	defender
6	7	champion_house
6	19	champion_house
\.


--
-- TOC entry 5190 (class 0 OID 33272)
-- Dependencies: 237
-- Data for Name: event_persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_persons (event_id, person_id, role, side) FROM stdin;
1	1	executed	Stark
1	10	witness/power	Lannister
1	13	orders_execution	Baratheon
2	17	commander	Baratheon
2	12	defender	Lannister
2	21	commander	Baratheon
3	3	victim	Stark
3	2	victim	Stark/Tully
3	34	host	Frey
3	35	betrayer	Bolton
4	13	victim	Baratheon
4	22	bride	Tyrell
4	23	conspirator (show hint)	Tyrell
5	8	commander	Stark
5	36	commander	Bolton
6	40	champion	Martell
6	45	champion	Clegane
\.


--
-- TOC entry 5189 (class 0 OID 33258)
-- Dependencies: 236
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, name, type, year, location, description) FROM stdin;
1	Execution of Eddard Stark	OTHER	299	King's Landing	Public execution.
2	Battle of the Blackwater	BATTLE	300	Blackwater Bay	Stannis attacks King's Landing.
3	The Red Wedding	WEDDING	299	The Twins	Massacre at a wedding.
4	The Purple Wedding	WEDDING	300	King's Landing	Joffrey poisoned at his wedding feast.
5	Battle of the Bastards	BATTLE	303	Near Winterfell	Jon Snow vs Ramsay Bolton.
6	Trial by Combat (Oberyn vs Mountain)	COUNCIL	300	King's Landing	Oberyn fights Gregor; outcome fatal.
\.


--
-- TOC entry 5187 (class 0 OID 33233)
-- Dependencies: 234
-- Data for Name: house_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.house_relations (id, from_house_id, to_house_id, type, start_year, end_year, note) FROM stdin;
1	1	4	ENEMY	299	300	War of the Five Kings
2	1	2	ALLY	299	300	Alliance via marriage/war
3	5	4	ALLY	300	303	Marriage/King's Landing politics
4	8	1	ENEMY	299	300	Ironborn raids
\.


--
-- TOC entry 5175 (class 0 OID 33071)
-- Dependencies: 222
-- Data for Name: houses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.houses (id, name, region_id, is_great, parent_id, seat, words, sigil_url, description) FROM stdin;
1	House Stark	1	t	\N	Winterfell	Winter is Coming	\N	Great house of the North.
2	House Tully	2	t	\N	Riverrun	Family, Duty, Honor	\N	Great house of the Riverlands.
3	House Arryn	3	t	\N	The Eyrie	As High as Honor	\N	Great house of the Vale.
4	House Lannister	4	t	\N	Casterly Rock	Hear Me Roar!	\N	Great house of the Westerlands.
5	House Tyrell	5	t	\N	Highgarden	Growing Strong	\N	Great house of the Reach.
6	House Baratheon	6	t	\N	Storm's End	Ours is the Fury	\N	Great house of the Stormlands.
7	House Martell	7	t	\N	Sunspear	Unbowed, Unbent, Unbroken	\N	Great house of Dorne.
8	House Greyjoy	8	t	\N	Pyke	We Do Not Sow	\N	Great house of the Iron Islands.
9	House Targaryen	9	t	\N	Dragonstone	Fire and Blood	\N	Former ruling house, claimant house.
10	House Umber	1	f	1	Last Hearth	\N	\N	\N
11	House Bolton	1	f	1	The Dreadfort	Our Blades Are Sharp	\N	\N
12	House Mormont	1	f	1	Bear Island	\N	\N	\N
13	House Frey	2	f	2	The Twins	\N	\N	\N
14	House Blackwood	2	f	2	Raventree Hall	\N	\N	\N
15	House Bracken	2	f	2	Stone Hedge	\N	\N	\N
16	House Royce	3	f	3	Runestone	\N	\N	\N
17	House Baelish	3	f	3	The Fingers	\N	\N	\N
18	House Corbray	3	f	3	Heart's Home	\N	\N	\N
19	House Clegane	4	f	4	Clegane's Keep	\N	\N	\N
20	House Lydden	4	f	4	Deep Den	\N	\N	\N
21	House Crakehall	4	f	4	Crakehall	\N	\N	\N
22	House Tarly	5	f	5	Horn Hill	First in Battle	\N	\N
23	House Hightower	5	f	5	Oldtown	\N	\N	\N
24	House Redwyne	5	f	5	The Arbor	\N	\N	\N
25	House Florent	5	f	6	\N	\N	\N	\N
26	House Tarth	6	f	6	Evenfall Hall	\N	\N	\N
27	House Seaworth	6	f	6	\N	\N	\N	\N
28	House Sand (bastards of Dorne)	7	f	7	\N	\N	\N	\N
29	House Dayne	7	f	7	Starfall	\N	\N	\N
30	House Yronwood	7	f	7	Yronwood	\N	\N	\N
31	House Harlaw	8	f	8	\N	\N	\N	\N
32	House Botley	8	f	8	\N	\N	\N	\N
33	House Goodbrother	8	f	8	\N	\N	\N	\N
34	House Velaryon	9	f	9	Driftmark	\N	\N	\N
35	House Celtigar	9	f	9	Claw Isle	\N	\N	\N
36	House Bar Emmon	9	f	9	Sharp Point	\N	\N	\N
\.


--
-- TOC entry 5182 (class 0 OID 33175)
-- Dependencies: 229
-- Data for Name: marriages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marriages (id, spouse1_id, spouse2_id, start_year, end_year, note) FROM stdin;
1	1	2	283	299	Marriage
2	32	31	288	298	Marriage
3	16	10	284	298	Royal marriage
4	13	22	300	300	Marriage (Purple Wedding year)
5	12	4	300	301	Political marriage (show)
\.


--
-- TOC entry 5180 (class 0 OID 33153)
-- Dependencies: 227
-- Data for Name: parent_child; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parent_child (parent_id, child_id, relation) FROM stdin;
1	3	BIOLOGICAL
2	3	BIOLOGICAL
1	4	BIOLOGICAL
2	4	BIOLOGICAL
1	5	BIOLOGICAL
2	5	BIOLOGICAL
1	6	BIOLOGICAL
2	6	BIOLOGICAL
1	7	BIOLOGICAL
2	7	BIOLOGICAL
9	10	BIOLOGICAL
9	11	BIOLOGICAL
9	12	BIOLOGICAL
16	13	LEGAL
10	13	BIOLOGICAL
16	14	LEGAL
10	14	BIOLOGICAL
16	15	LEGAL
10	15	BIOLOGICAL
28	29	BIOLOGICAL
28	27	BIOLOGICAL
28	26	BIOLOGICAL
38	37	BIOLOGICAL
38	39	BIOLOGICAL
\.


--
-- TOC entry 5178 (class 0 OID 33116)
-- Dependencies: 225
-- Data for Name: person_aliases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_aliases (person_id, alias) FROM stdin;
2	Catelyn Stark
8	Aegon Targaryen
6	Three-Eyed Raven
26	Dany
30	Littlefinger
44	The Hound
45	The Mountain
\.


--
-- TOC entry 5179 (class 0 OID 33130)
-- Dependencies: 226
-- Data for Name: person_house_affiliations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_house_affiliations (person_id, house_id, type, start_year, end_year, note) FROM stdin;
1	1	BORN_IN	\N	\N	\N
3	1	BORN_IN	\N	\N	\N
4	1	BORN_IN	\N	\N	\N
5	1	BORN_IN	\N	\N	\N
6	1	BORN_IN	\N	\N	\N
7	1	BORN_IN	\N	\N	\N
2	2	BORN_IN	\N	\N	Born a Tully
31	2	BORN_IN	\N	\N	Born a Tully
9	4	BORN_IN	\N	\N	\N
10	4	BORN_IN	\N	\N	\N
11	4	BORN_IN	\N	\N	\N
12	4	BORN_IN	\N	\N	\N
16	6	BORN_IN	\N	\N	\N
17	6	BORN_IN	\N	\N	\N
18	6	BORN_IN	\N	\N	\N
22	5	BORN_IN	\N	\N	\N
23	5	BORN_IN	\N	\N	\N
26	9	BORN_IN	\N	\N	\N
27	9	BORN_IN	\N	\N	\N
28	9	BORN_IN	\N	\N	\N
29	9	BORN_IN	\N	\N	\N
34	13	BORN_IN	\N	\N	\N
35	11	BORN_IN	\N	\N	\N
36	11	BORN_IN	\N	\N	\N
37	8	BORN_IN	\N	\N	\N
38	8	BORN_IN	\N	\N	\N
39	8	BORN_IN	\N	\N	\N
40	7	BORN_IN	\N	\N	\N
42	7	BORN_IN	\N	\N	\N
43	26	BORN_IN	\N	\N	\N
44	19	BORN_IN	\N	\N	\N
45	19	BORN_IN	\N	\N	\N
2	1	BY_MARRIAGE	\N	\N	Married into House Stark
31	3	BY_MARRIAGE	\N	\N	Married into House Arryn
10	6	BY_MARRIAGE	\N	\N	Queen consort via marriage
22	6	BY_MARRIAGE	\N	\N	Marriage alliances (show)
8	1	OTHER	\N	\N	Raised at Winterfell
8	9	OTHER	\N	\N	True parentage (show reveal)
37	1	HOSTAGE	\N	\N	Ward/hostage at Winterfell
21	6	SWORN	\N	\N	Sworn to Stannis/Baratheon cause
\.


--
-- TOC entry 5185 (class 0 OID 33210)
-- Dependencies: 232
-- Data for Name: person_titles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_titles (person_id, title_id, start_year, end_year, note) FROM stdin;
1	1	283	299	\N
1	2	283	299	\N
1	3	298	299	Served Robert
3	4	299	299	Declared in the war
16	10	283	298	\N
10	5	300	303	For Tommen
8	6	301	303	\N
26	7	298	305	\N
26	8	300	305	\N
9	9	242	300	\N
\.


--
-- TOC entry 5177 (class 0 OID 33099)
-- Dependencies: 224
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (id, full_name, sex, status, born_year, died_year, description) FROM stdin;
1	Eddard Stark	MALE	DEAD	263	299	\N
2	Catelyn Tully	FEMALE	DEAD	264	299	\N
3	Robb Stark	MALE	DEAD	283	299	\N
4	Sansa Stark	FEMALE	ALIVE	286	\N	\N
5	Arya Stark	FEMALE	ALIVE	289	\N	\N
6	Bran Stark	MALE	ALIVE	290	\N	\N
7	Rickon Stark	MALE	DEAD	295	303	\N
8	Jon Snow	MALE	ALIVE	283	\N	\N
9	Tywin Lannister	MALE	DEAD	242	300	\N
10	Cersei Lannister	FEMALE	DEAD	266	305	\N
11	Jaime Lannister	MALE	DEAD	266	305	\N
12	Tyrion Lannister	MALE	ALIVE	273	\N	\N
13	Joffrey Baratheon	MALE	DEAD	286	300	\N
14	Myrcella Baratheon	FEMALE	DEAD	290	303	\N
15	Tommen Baratheon	MALE	DEAD	291	303	\N
16	Robert Baratheon	MALE	DEAD	262	298	\N
17	Stannis Baratheon	MALE	DEAD	264	304	\N
18	Renly Baratheon	MALE	DEAD	277	299	\N
19	Shireen Baratheon	FEMALE	DEAD	289	304	\N
20	Melisandre	FEMALE	UNKNOWN	\N	\N	\N
21	Davos Seaworth	MALE	ALIVE	266	\N	\N
22	Margaery Tyrell	FEMALE	DEAD	283	303	\N
23	Olenna Tyrell	FEMALE	DEAD	228	304	\N
24	Loras Tyrell	MALE	DEAD	282	303	\N
25	Mace Tyrell	MALE	DEAD	256	303	\N
26	Daenerys Targaryen	FEMALE	DEAD	284	305	\N
27	Viserys Targaryen	MALE	DEAD	276	298	\N
28	Aerys II Targaryen	MALE	DEAD	244	283	\N
29	Rhaegar Targaryen	MALE	DEAD	259	283	\N
30	Petyr Baelish	MALE	DEAD	268	305	\N
31	Lysa Arryn	FEMALE	DEAD	266	300	\N
32	Jon Arryn	MALE	DEAD	230	298	\N
33	Robin Arryn	MALE	ALIVE	294	\N	\N
34	Walder Frey	MALE	DEAD	208	304	\N
35	Roose Bolton	MALE	DEAD	260	304	\N
36	Ramsay Bolton	MALE	DEAD	282	304	\N
37	Theon Greyjoy	MALE	DEAD	287	305	\N
38	Balon Greyjoy	MALE	DEAD	260	300	\N
39	Yara Greyjoy	FEMALE	ALIVE	283	\N	\N
40	Oberyn Martell	MALE	DEAD	258	300	\N
41	Ellaria Sand	FEMALE	DEAD	275	303	\N
42	Doran Martell	MALE	DEAD	247	303	\N
43	Brienne of Tarth	FEMALE	ALIVE	280	\N	\N
44	Sandor Clegane	MALE	ALIVE	270	\N	\N
45	Gregor Clegane	MALE	DEAD	268	303	\N
\.


--
-- TOC entry 5173 (class 0 OID 33060)
-- Dependencies: 220
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (id, name) FROM stdin;
1	The North
2	The Riverlands
3	The Vale
4	The Westerlands
5	The Reach
6	The Stormlands
7	Dorne
8	The Iron Islands
9	The Crownlands
10	Beyond the Wall
\.


--
-- TOC entry 5184 (class 0 OID 33200)
-- Dependencies: 231
-- Data for Name: titles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.titles (id, name) FROM stdin;
1	Lord of Winterfell
2	Warden of the North
3	Hand of the King
4	King in the North
5	Queen Regent
6	Lord Commander of the Night's Watch
7	Khaleesi
8	Breaker of Chains
9	Lord of Casterly Rock
10	King of the Seven Kingdoms
\.


--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 235
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.events_id_seq', 6, true);


--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 233
-- Name: house_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.house_relations_id_seq', 4, true);


--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 221
-- Name: houses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.houses_id_seq', 37, true);


--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 228
-- Name: marriages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.marriages_id_seq', 5, true);


--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 223
-- Name: persons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_id_seq', 45, true);


--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 219
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_id_seq', 20, true);


--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 230
-- Name: titles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.titles_id_seq', 10, true);


--
-- TOC entry 5003 (class 2606 OID 33295)
-- Name: event_houses event_houses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_houses
    ADD CONSTRAINT event_houses_pkey PRIMARY KEY (event_id, house_id);


--
-- TOC entry 5001 (class 2606 OID 33278)
-- Name: event_persons event_persons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_persons
    ADD CONSTRAINT event_persons_pkey PRIMARY KEY (event_id, person_id);


--
-- TOC entry 4997 (class 2606 OID 33271)
-- Name: events events_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_name_key UNIQUE (name);


--
-- TOC entry 4999 (class 2606 OID 33269)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 4995 (class 2606 OID 33246)
-- Name: house_relations house_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.house_relations
    ADD CONSTRAINT house_relations_pkey PRIMARY KEY (id);


--
-- TOC entry 4963 (class 2606 OID 33084)
-- Name: houses houses_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.houses
    ADD CONSTRAINT houses_name_key UNIQUE (name);


--
-- TOC entry 4965 (class 2606 OID 33082)
-- Name: houses houses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.houses
    ADD CONSTRAINT houses_pkey PRIMARY KEY (id);


--
-- TOC entry 4985 (class 2606 OID 33187)
-- Name: marriages marriages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marriages
    ADD CONSTRAINT marriages_pkey PRIMARY KEY (id);


--
-- TOC entry 4983 (class 2606 OID 33162)
-- Name: parent_child parent_child_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_child
    ADD CONSTRAINT parent_child_pkey PRIMARY KEY (parent_id, child_id);


--
-- TOC entry 4974 (class 2606 OID 33124)
-- Name: person_aliases person_aliases_alias_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_aliases
    ADD CONSTRAINT person_aliases_alias_key UNIQUE (alias);


--
-- TOC entry 4976 (class 2606 OID 33122)
-- Name: person_aliases person_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_aliases
    ADD CONSTRAINT person_aliases_pkey PRIMARY KEY (person_id, alias);


--
-- TOC entry 4980 (class 2606 OID 33140)
-- Name: person_house_affiliations person_house_affiliations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_house_affiliations
    ADD CONSTRAINT person_house_affiliations_pkey PRIMARY KEY (person_id, house_id, type);


--
-- TOC entry 4993 (class 2606 OID 33220)
-- Name: person_titles person_titles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_titles
    ADD CONSTRAINT person_titles_pkey PRIMARY KEY (person_id, title_id, start_year);


--
-- TOC entry 4970 (class 2606 OID 33115)
-- Name: persons persons_full_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_full_name_key UNIQUE (full_name);


--
-- TOC entry 4972 (class 2606 OID 33113)
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (id);


--
-- TOC entry 4959 (class 2606 OID 33069)
-- Name: regions regions_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_name_key UNIQUE (name);


--
-- TOC entry 4961 (class 2606 OID 33067)
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- TOC entry 4988 (class 2606 OID 33209)
-- Name: titles titles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.titles
    ADD CONSTRAINT titles_name_key UNIQUE (name);


--
-- TOC entry 4990 (class 2606 OID 33207)
-- Name: titles titles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.titles
    ADD CONSTRAINT titles_pkey PRIMARY KEY (id);


--
-- TOC entry 4977 (class 1259 OID 33151)
-- Name: idx_aff_house; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_aff_house ON public.person_house_affiliations USING btree (house_id);


--
-- TOC entry 4978 (class 1259 OID 33152)
-- Name: idx_aff_person; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_aff_person ON public.person_house_affiliations USING btree (person_id);


--
-- TOC entry 4966 (class 1259 OID 33097)
-- Name: idx_houses_great; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_houses_great ON public.houses USING btree (is_great);


--
-- TOC entry 4967 (class 1259 OID 33096)
-- Name: idx_houses_parent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_houses_parent ON public.houses USING btree (parent_id);


--
-- TOC entry 4968 (class 1259 OID 33095)
-- Name: idx_houses_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_houses_region ON public.houses USING btree (region_id);


--
-- TOC entry 4981 (class 1259 OID 33173)
-- Name: idx_pc_child; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pc_child ON public.parent_child USING btree (child_id);


--
-- TOC entry 4991 (class 1259 OID 33231)
-- Name: idx_pt_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pt_title ON public.person_titles USING btree (title_id);


--
-- TOC entry 4986 (class 1259 OID 33198)
-- Name: ux_marriage_pair; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ux_marriage_pair ON public.marriages USING btree (LEAST(spouse1_id, spouse2_id), GREATEST(spouse1_id, spouse2_id));


--
-- TOC entry 5021 (class 2620 OID 33320)
-- Name: houses bannerman_parent_check; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER bannerman_parent_check BEFORE INSERT OR UPDATE ON public.houses FOR EACH ROW EXECUTE FUNCTION public.trg_bannerman_parent_must_be_great();


--
-- TOC entry 5019 (class 2606 OID 33296)
-- Name: event_houses event_houses_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_houses
    ADD CONSTRAINT event_houses_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- TOC entry 5020 (class 2606 OID 33301)
-- Name: event_houses event_houses_house_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_houses
    ADD CONSTRAINT event_houses_house_id_fkey FOREIGN KEY (house_id) REFERENCES public.houses(id) ON DELETE CASCADE;


--
-- TOC entry 5017 (class 2606 OID 33279)
-- Name: event_persons event_persons_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_persons
    ADD CONSTRAINT event_persons_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- TOC entry 5018 (class 2606 OID 33284)
-- Name: event_persons event_persons_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_persons
    ADD CONSTRAINT event_persons_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5015 (class 2606 OID 33247)
-- Name: house_relations house_relations_from_house_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.house_relations
    ADD CONSTRAINT house_relations_from_house_id_fkey FOREIGN KEY (from_house_id) REFERENCES public.houses(id) ON DELETE CASCADE;


--
-- TOC entry 5016 (class 2606 OID 33252)
-- Name: house_relations house_relations_to_house_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.house_relations
    ADD CONSTRAINT house_relations_to_house_id_fkey FOREIGN KEY (to_house_id) REFERENCES public.houses(id) ON DELETE CASCADE;


--
-- TOC entry 5004 (class 2606 OID 33090)
-- Name: houses houses_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.houses
    ADD CONSTRAINT houses_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.houses(id) ON DELETE SET NULL;


--
-- TOC entry 5005 (class 2606 OID 33085)
-- Name: houses houses_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.houses
    ADD CONSTRAINT houses_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id) ON DELETE SET NULL;


--
-- TOC entry 5011 (class 2606 OID 33188)
-- Name: marriages marriages_spouse1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marriages
    ADD CONSTRAINT marriages_spouse1_id_fkey FOREIGN KEY (spouse1_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5012 (class 2606 OID 33193)
-- Name: marriages marriages_spouse2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marriages
    ADD CONSTRAINT marriages_spouse2_id_fkey FOREIGN KEY (spouse2_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5009 (class 2606 OID 33168)
-- Name: parent_child parent_child_child_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_child
    ADD CONSTRAINT parent_child_child_id_fkey FOREIGN KEY (child_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5010 (class 2606 OID 33163)
-- Name: parent_child parent_child_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent_child
    ADD CONSTRAINT parent_child_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5006 (class 2606 OID 33125)
-- Name: person_aliases person_aliases_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_aliases
    ADD CONSTRAINT person_aliases_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5007 (class 2606 OID 33146)
-- Name: person_house_affiliations person_house_affiliations_house_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_house_affiliations
    ADD CONSTRAINT person_house_affiliations_house_id_fkey FOREIGN KEY (house_id) REFERENCES public.houses(id) ON DELETE CASCADE;


--
-- TOC entry 5008 (class 2606 OID 33141)
-- Name: person_house_affiliations person_house_affiliations_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_house_affiliations
    ADD CONSTRAINT person_house_affiliations_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5013 (class 2606 OID 33221)
-- Name: person_titles person_titles_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_titles
    ADD CONSTRAINT person_titles_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- TOC entry 5014 (class 2606 OID 33226)
-- Name: person_titles person_titles_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_titles
    ADD CONSTRAINT person_titles_title_id_fkey FOREIGN KEY (title_id) REFERENCES public.titles(id) ON DELETE CASCADE;


-- Completed on 2026-01-27 00:18:09

--
-- PostgreSQL database dump complete
--

\unrestrict XPRmvivb2O1tq9Lq9EXw17YFns69b8O8izSbKxnHc4Sn8Cf3xaYMZTETxXDVz7w

