--
-- PostgreSQL database dump
--

\restrict 5UswzotgvGX1OFkNOfLMpvLC4eILzrsEoQXy8EzQzseMVzrbM6Kk17JS0TerqWd

-- Dumped from database version 17.12
-- Dumped by pg_dump version 17.12

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

ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_user_id_c564eba6_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_content_type_id_c4bce8eb_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_group_id_97559544_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_2f476e4b_fk_django_co;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
DROP INDEX IF EXISTS public.django_session_session_key_c0390e0f_like;
DROP INDEX IF EXISTS public.django_session_expire_date_a5c62663;
DROP INDEX IF EXISTS public.django_admin_log_user_id_c564eba6;
DROP INDEX IF EXISTS public.django_admin_log_content_type_id_c4bce8eb;
DROP INDEX IF EXISTS public.content_car_slug_cca5d446_like;
DROP INDEX IF EXISTS public.content_article_slug_d023fc80_like;
DROP INDEX IF EXISTS public.auth_user_username_6821ab7c_like;
DROP INDEX IF EXISTS public.auth_user_user_permissions_user_id_a95ead1b;
DROP INDEX IF EXISTS public.auth_user_user_permissions_permission_id_1fbb5f2c;
DROP INDEX IF EXISTS public.auth_user_groups_user_id_6a12ed8b;
DROP INDEX IF EXISTS public.auth_user_groups_group_id_97559544;
DROP INDEX IF EXISTS public.auth_permission_content_type_id_2f476e4b;
DROP INDEX IF EXISTS public.auth_group_permissions_permission_id_84c5c92e;
DROP INDEX IF EXISTS public.auth_group_permissions_group_id_b120cbf9;
DROP INDEX IF EXISTS public.auth_group_name_a6ea08ec_like;
ALTER TABLE IF EXISTS ONLY public.django_session DROP CONSTRAINT IF EXISTS django_session_pkey;
ALTER TABLE IF EXISTS ONLY public.django_migrations DROP CONSTRAINT IF EXISTS django_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_pkey;
ALTER TABLE IF EXISTS ONLY public.django_content_type DROP CONSTRAINT IF EXISTS django_content_type_app_label_model_76bd3d3b_uniq;
ALTER TABLE IF EXISTS ONLY public.django_admin_log DROP CONSTRAINT IF EXISTS django_admin_log_pkey;
ALTER TABLE IF EXISTS ONLY public.content_websitesettings DROP CONSTRAINT IF EXISTS content_websitesettings_pkey;
ALTER TABLE IF EXISTS ONLY public.content_review DROP CONSTRAINT IF EXISTS content_review_pkey;
ALTER TABLE IF EXISTS ONLY public.content_lead DROP CONSTRAINT IF EXISTS content_lead_pkey;
ALTER TABLE IF EXISTS ONLY public.content_car DROP CONSTRAINT IF EXISTS content_car_slug_cca5d446_uniq;
ALTER TABLE IF EXISTS ONLY public.content_car DROP CONSTRAINT IF EXISTS content_car_pkey;
ALTER TABLE IF EXISTS ONLY public.content_articlegenerationsettings DROP CONSTRAINT IF EXISTS content_articlegenerationsettings_pkey;
ALTER TABLE IF EXISTS ONLY public.content_article DROP CONSTRAINT IF EXISTS content_article_slug_d023fc80_uniq;
ALTER TABLE IF EXISTS ONLY public.content_article DROP CONSTRAINT IF EXISTS content_article_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_username_key;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_user_permissions DROP CONSTRAINT IF EXISTS auth_user_user_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user DROP CONSTRAINT IF EXISTS auth_user_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_user_id_group_id_94350c0c_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_user_groups DROP CONSTRAINT IF EXISTS auth_user_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_permission DROP CONSTRAINT IF EXISTS auth_permission_content_type_id_codename_01ab375a_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_pkey;
ALTER TABLE IF EXISTS ONLY public.auth_group_permissions DROP CONSTRAINT IF EXISTS auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
ALTER TABLE IF EXISTS ONLY public.auth_group DROP CONSTRAINT IF EXISTS auth_group_name_key;
DROP TABLE IF EXISTS public.django_session;
DROP TABLE IF EXISTS public.django_migrations;
DROP TABLE IF EXISTS public.django_content_type;
DROP TABLE IF EXISTS public.django_admin_log;
DROP TABLE IF EXISTS public.content_websitesettings;
DROP TABLE IF EXISTS public.content_review;
DROP TABLE IF EXISTS public.content_lead;
DROP TABLE IF EXISTS public.content_car;
DROP TABLE IF EXISTS public.content_articlegenerationsettings;
DROP TABLE IF EXISTS public.content_article;
DROP TABLE IF EXISTS public.auth_user_user_permissions;
DROP TABLE IF EXISTS public.auth_user_groups;
DROP TABLE IF EXISTS public.auth_user;
DROP TABLE IF EXISTS public.auth_permission;
DROP TABLE IF EXISTS public.auth_group_permissions;
DROP TABLE IF EXISTS public.auth_group;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_article; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_article (
    id bigint NOT NULL,
    title character varying(160) NOT NULL,
    excerpt character varying(320) NOT NULL,
    content text NOT NULL,
    is_published boolean NOT NULL,
    generated_by character varying(120) NOT NULL,
    published_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    slug character varying(190) NOT NULL
);


--
-- Name: content_article_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.content_article ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.content_article_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_articlegenerationsettings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_articlegenerationsettings (
    id bigint NOT NULL,
    prompt text NOT NULL,
    interval_days smallint NOT NULL,
    is_enabled boolean NOT NULL,
    last_attempt_at timestamp with time zone,
    last_generated_at timestamp with time zone,
    last_error text NOT NULL,
    generation_in_progress boolean NOT NULL,
    generation_started_at timestamp with time zone,
    CONSTRAINT content_articlegenerationsettings_interval_days_check CHECK ((interval_days >= 0))
);


--
-- Name: content_articlegenerationsettings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.content_articlegenerationsettings ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.content_articlegenerationsettings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_car; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_car (
    id bigint NOT NULL,
    "position" integer NOT NULL,
    is_active boolean NOT NULL,
    name character varying(160) NOT NULL,
    year smallint NOT NULL,
    price_eur integer NOT NULL,
    image character varying(200) NOT NULL,
    slug character varying(190) NOT NULL,
    summary character varying(320) NOT NULL,
    mileage_km integer,
    engine character varying(120) NOT NULL,
    power_hp smallint,
    fuel character varying(80) NOT NULL,
    transmission character varying(120) NOT NULL,
    drivetrain character varying(80) NOT NULL,
    body_type character varying(80) NOT NULL,
    color character varying(80) NOT NULL,
    vin character varying(64) NOT NULL,
    condition character varying(120) NOT NULL,
    location character varying(160) NOT NULL,
    description text NOT NULL,
    features text NOT NULL,
    CONSTRAINT content_car_mileage_km_check CHECK ((mileage_km >= 0)),
    CONSTRAINT content_car_position_check CHECK (("position" >= 0)),
    CONSTRAINT content_car_power_hp_check CHECK ((power_hp >= 0)),
    CONSTRAINT content_car_price_eur_check CHECK ((price_eur >= 0)),
    CONSTRAINT content_car_year_check CHECK ((year >= 0))
);


--
-- Name: content_car_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.content_car ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.content_car_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_lead; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_lead (
    id bigint NOT NULL,
    phone character varying(30) NOT NULL,
    country character varying(2) NOT NULL,
    source character varying(80) NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: content_lead_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.content_lead ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.content_lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_review; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_review (
    id bigint NOT NULL,
    "position" integer NOT NULL,
    is_active boolean NOT NULL,
    name character varying(160) NOT NULL,
    vehicle character varying(200) NOT NULL,
    text text NOT NULL,
    image character varying(200) NOT NULL,
    CONSTRAINT content_review_position_check CHECK (("position" >= 0))
);


--
-- Name: content_review_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.content_review ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.content_review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_websitesettings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_websitesettings (
    id bigint NOT NULL,
    phone character varying(40) NOT NULL,
    email character varying(254) NOT NULL,
    address character varying(300) NOT NULL
);


--
-- Name: content_websitesettings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.content_websitesettings ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.content_websitesettings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add car	7	add_car
26	Can change car	7	change_car
27	Can delete car	7	delete_car
28	Can view car	7	view_car
29	Can add faq	8	add_faq
30	Can change faq	8	change_faq
31	Can delete faq	8	delete_faq
32	Can view faq	8	view_faq
33	Can add lead	9	add_lead
34	Can change lead	9	change_lead
35	Can delete lead	9	delete_lead
36	Can view lead	9	view_lead
37	Can add manager	10	add_manager
38	Can change manager	10	change_manager
39	Can delete manager	10	delete_manager
40	Can view manager	10	view_manager
41	Can add review	11	add_review
42	Can change review	11	change_review
43	Can delete review	11	delete_review
44	Can view review	11	view_review
45	Can add page text	12	add_pagetext
46	Can change page text	12	change_pagetext
47	Can delete page text	12	delete_pagetext
48	Can view page text	12	view_pagetext
49	Can add article	13	add_article
50	Can change article	13	change_article
51	Can delete article	13	delete_article
52	Can view article	13	view_article
53	Can add article generation settings	14	add_articlegenerationsettings
54	Can change article generation settings	14	change_articlegenerationsettings
55	Can delete article generation settings	14	delete_articlegenerationsettings
56	Can view article generation settings	14	view_articlegenerationsettings
57	Can add website settings	15	add_websitesettings
58	Can change website settings	15	change_websitesettings
59	Can delete website settings	15	delete_websitesettings
60	Can view website settings	15	view_websitesettings
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
2	pbkdf2_sha256$1000000$7vudXDRSZuKakSY4q9Gxbb$hTBiXeyA1eWs9N8SXZYwnnrtHWA65ft4l37HVILV7UQ=	2026-11-23 08:45:57.66411+00	t	admin			admin@sample.com	t	t	2026-11-23 08:45:53.081089+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: content_article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_article (id, title, excerpt, content, is_published, generated_by, published_at, updated_at, slug) FROM stdin;
9	Как да изберем семеен SUV според реалните си нужди	Размерът и външният вид не са достатъчни. Сравнете пространството, безопасността, разходите и удобството в ежедневието.	SUV моделите са популярни заради високата позиция на седене, практичния багажник и усещането за сигурност. Разликите между отделните автомобили обаче са големи. Някои са удобни в града, други предлагат истински седем места, а трети са създадени за теглене и лоши пътища. Правилният избор започва с честен списък на ежедневните нужди.\n\nОпределете необходимия размер\n\nКомпактният SUV е лесен за паркиране и обикновено има по-нисък разход, но мястото на втория ред и багажникът могат да бъдат ограничени. Средноразмерният модел предлага добър баланс за семейство с две деца. Големият SUV има повече пространство и възможност за седем места, но изисква по-голям бюджет за гориво, гуми и обслужване.\n\nИзпробвайте втория и третия ред\n\nНе разчитайте само на каталожните размери. Монтирайте детското столче и проверете дали предната седалка остава удобна. Вижте колко широко се отварят задните врати и дали прагът затруднява качването. При седемместен модел обърнете внимание на достъпа до третия ред и на оставащия багажник, когато всички места се използват.\n\nОценете багажника с реални предмети\n\nОбемът в литри не показва цялата картина. Формата на багажника, височината на прага и наличието на равен под често са по-важни. Помислете дали ще превозвате детска количка, велосипеди, домашен любимец или голям багаж за почивка. Проверете как се сгъват седалките и къде се съхранява щората.\n\nИзберете правилното задвижване\n\nЗадвижването на четирите колела е полезно при сняг, стръмни пътища и теглене, но не е задължително за всеки. То добавя тегло и компоненти за обслужване. За основно градско движение вариант с предно предаване и качествени гуми може да бъде по-разумен. Ако теглите каравана или ремарке, проверете допустимата маса и необходимото охлаждане на трансмисията.\n\nРазгледайте системите за безопасност\n\nТърсете автоматично аварийно спиране, следене на мъртвата зона, предупреждение за напречен трафик и качествени точки ISOFIX. Проверете резултатите от независими краш тестове за конкретната година и версия. Асистентите са полезни, но добрата видимост и предвидимото управление остават важни.\n\nИзчислете разходите след покупката\n\nПо-големите джанти изглеждат ефектно, но гумите са по-скъпи и возията може да е по-твърда. Сравнете цените на консумативите, застраховката, данъка и типичните ремонти. Проверете реалния разход на собственици, а не само официалните стойности.\n\nНаправете семейно тестово шофиране\n\nИзпробвайте автомобила с хората, които ще го използват. Минете по тесни улици, паркирайте и проверете шума при по-висока скорост. Удобният семеен SUV не е непременно най-големият или най-мощният. Той е този, който улеснява ежедневието, побира необходимото и остава разумен за поддръжка.	t	manual-preview	2026-11-23 09:53:10.362309+00	2026-11-23 09:53:10.362319+00	kak-da-izberem-semeen-suv-spored-realnite-si-nuzhdi
4	Как да изберем автомобил от САЩ без неприятни изненади	Практичен списък с най-важните проверки преди участие в търг — от историята на автомобила до реалната крайна цена.	Покупката на автомобил от САЩ може да осигури богато оборудване, интересен модел и добра цена. Успешната сделка обаче започва много преди наддаването. Най-важната стъпка е да изградите ясен бюджет и да проверите конкретния автомобил, вместо да разчитате само на снимките.\n\nОпределете реалния бюджет\n\nЦената на търга е само част от общия разход. Към нея се добавят такси на аукциона, вътрешен транспорт в САЩ, морски транспорт, митнически разходи, доставка, регистрация и евентуален ремонт. Предвидете и резерв за непредвидени разходи. Така няма да се налага да правите компромиси в последния етап.\n\nПроверете VIN номера\n\nVIN номерът е основният източник на информация за историята на автомобила. Чрез него могат да се открият данни за предишни щети, сервизни посещения, отчетен пробег, промени в собствеността и стари обяви. Сравнявайте информацията от няколко източника. Несъответствие в пробега или липсващ период изискват допълнителна проверка.\n\nРазгледайте внимателно снимките\n\nОбърнете внимание на разстоянията между панелите, въздушните възглавници, течовете под автомобила, гумите и следите от вода в купето. Снимка на работещото табло може да покаже предупредителни лампи и реалния пробег. Липсата на ключ или обозначение, че автомобилът не стартира, също увеличава риска.\n\nОценете вида на щетата\n\nКозметичната повреда обикновено е по-предвидима от деформация на носещата конструкция. Наводнен автомобил може да изглежда добре, но да развие електрически проблеми месеци по-късно. При удар отпред проверете риска от повреда на охлаждането, окачването и системите за безопасност.\n\nНе наддавайте емоционално\n\nОпределете максимална сума предварително и не я надвишавайте. Търговете създават усещане за спешност, което лесно води до плащане над разумната цена. Ако конкретният автомобил стане твърде скъп, изчакайте следващия подходящ вариант.\n\nНай-сигурният подход е комбинация от проверена история, техническа оценка и реалистична калкулация. Когато всяка стъпка е планирана, покупката от САЩ може да бъде прозрачна, предвидима и действително изгодна.	t	manual-preview	2026-11-23 09:13:40.942797+00	2026-11-23 09:13:40.942816+00	kak-da-izberem-avtomobil-ot-sasht-bez-nepriyatni-iznenadi
5	Хибрид, бензин или дизел: кое задвижване е подходящо за вас	Сравняваме основните видове задвижване според градското шофиране, дългите пътувания, поддръжката и общите разходи.	Изборът между бензинов, дизелов и хибриден автомобил не трябва да се основава само на каталожния разход. Най-доброто задвижване зависи от ежедневния маршрут, годишния пробег, възможностите за обслужване и начина, по който използвате автомобила.\n\nБензинов автомобил\n\nБензиновите двигатели са добър универсален избор при умерен годишен пробег. Те загряват бързо, работят тихо и са подходящи за кратки градски маршрути. Преди покупка проверете разхода на масло, запалителната система и сервизната история. За човек, който се движи основно в града, бензиновият вариант често предлага добър баланс между цена, комфорт и поддръжка.\n\nДизелов автомобил\n\nДизелът е логичен избор за редовни дълги пътувания и висок годишен пробег. Високият въртящ момент е удобен на магистрала, при изпреварване и теглене. При постоянна скорост дизеловият мотор може да бъде много икономичен.\n\nТой обаче не обича само кратки маршрути. Филтърът за твърди частици има нужда от условия за регенерация, а системите EGR и AdBlue изискват правилна експлоатация. Автомобил, който се движи само по няколко километра дневно, може да натрупа скъпи проблеми.\n\nСтандартен хибрид\n\nСамозареждащият се хибрид комбинира бензинов двигател и електромотор. Най-силната му страна е градското движение, където честото спиране позволява възстановяване на енергия. Той не изисква домашна зарядна станция. Важно е да се проверят високоволтовата батерия и нейната охладителна система.\n\nPlug-in хибрид\n\nPlug-in хибридът има по-голяма батерия и се зарежда от електрическата мрежа. Подходящ е, ако ежедневният маршрут може да бъде изминат на ток и имате удобно място за зареждане. Без редовно зареждане автомобилът носи допълнителното тегло на батерията, без да използва основното си предимство.\n\nКак да вземете решение\n\nЗапишете реалните си маршрути за една седмица. Ако преобладават кратки градски пътувания, бензинът или стандартният хибрид вероятно са по-подходящи. При ежедневна магистрала и висок пробег дизелът може да остане най-икономичният вариант. Plug-in хибридът има смисъл при предвидим маршрут и редовно зареждане.\n\nНяма универсален победител. Правилният избор е този, който съответства на реалната употреба, а не на временна тенденция или обещание за минимален разход.	t	manual-preview	2026-11-23 09:13:40.945846+00	2026-11-23 09:13:40.945855+00	hibrid-benzin-ili-dizel-koe-zadvizhvane-e-podhodyashto-za-vas
6	Подготовка на автомобила за дълго пътуване: практичен чеклист	Какво да проверите по гумите, течностите, спирачките и оборудването, преди да потеглите на семейна почивка или дълъг маршрут.	Дългото пътуване натоварва автомобила по различен начин от ежедневното движение в града. Високата скорост, пълният багажник и продължителната работа на двигателя могат да превърнат малък пропуск в сериозен проблем. Проверка няколко дни преди тръгване дава време за реакция.\n\nГуми и налягане\n\nПроверете налягането при студени гуми и го съобразете с препоръките на производителя за натоварен автомобил. Огледайте протектора за неравномерно износване, напукване и забити предмети. Не забравяйте резервната гума или комплекта за аварийно възстановяване.\n\nТечности\n\nПроверете моторното масло, охлаждащата течност, спирачната течност и течността за чистачки. Не отваряйте разширителния съд при горещ двигател. Ако автомобилът редовно губи масло или антифриз, открийте причината преди пътуването, вместо просто да доливате.\n\nСпирачки и окачване\n\nНеобичаен шум, вибрация във волана или дърпане на една страна изискват преглед. При планински маршрут спирачната система е особено важна. Накладките трябва да имат достатъчен остатъчен ресурс, а дисковете да нямат сериозно износване.\n\nСветлини и видимост\n\nПроверете къси и дълги светлини, мигачи, стопове и осветлението на регистрационния номер. Почистете стъклата отвътре и отвън. Износените чистачки намаляват видимостта точно когато са най-нужни.\n\nКлиматик и акумулатор\n\nКлиматичната система е важна и за концентрацията на водача. Ако охлажда слабо или издава необичаен шум, посетете сервиз предварително. Проверете акумулатора, особено ако стартерът върти по-бавно или батерията е на няколко години.\n\nДокументи и оборудване\n\nНосете свидетелство за регистрация, валидна застраховка, шофьорска книжка и документите, изисквани по маршрута. В автомобила трябва да има аптечка, пожарогасител, предупредителен триъгълник и светлоотразителна жилетка. Полезни са фенер, зарядно за телефон, вода и малък комплект инструменти.\n\nРазпределение на багажа\n\nПоставете тежките предмети ниско и близо до облегалките на задните седалки. Не оставяйте свободни вещи върху кората или седалките — при рязко спиране те могат да бъдат опасни. Проверете закрепването на багажник или кутия на покрива.\n\nДобрата подготовка не изисква сложни инструменти. Тя изисква последователност: гуми, течности, спирачки, светлини, документи и безопасно разпределен багаж. Този чеклист може да предотврати повреда и да ви помогне да стигнете спокойно до целта.	t	manual-preview	2026-11-23 09:13:40.946807+00	2026-11-23 09:13:40.946813+00	podgotovka-na-avtomobila-za-dalgo-patuvane-praktichen-cheklist
7	Какво да проверим по време на тестово шофиране	Тестовото шофиране разкрива проблеми, които не се виждат на снимки. Ето как да използвате времето зад волана максимално ефективно.	Тестовото шофиране не е просто кратка разходка, за да прецените дали седалката е удобна. То е възможност да проверите работата на двигателя, трансмисията, спирачките, окачването и електрониката в реални условия. За да получите полезна информация, подгответе се предварително и не позволявайте разговорът с продавача да отвлича вниманието ви.\n\nЗапочнете преди потеглянето\n\nОгледайте автомобила на дневна светлина и, ако е възможно, при студен двигател. Трудното стартиране, необичайният дим или силният шум в първите секунди могат да подскажат проблем. Проверете дали всички предупредителни лампи светват при подаване на контакт и изгасват след стартиране. Ако някоя лампа никога не се появява, тя може да е умишлено деактивирана.\n\nНастройте правилната позиция\n\nРегулирайте седалката, волана и огледалата. Уверете се, че виждате добре уредите и достигате педалите без напрежение. Проверете пространството за главата и краката, както и видимостта назад. Ако автомобилът ще се използва от няколко души, нека и другият водач изпробва позицията.\n\nСлушайте двигателя\n\nУскорявайте плавно и след това по-решително. Двигателят трябва да работи равномерно, без прекъсване, метален шум или силни вибрации. Следете температурата и поведението на оборотите. При отпускане на газта не трябва да има необичайно придърпване или гаснене.\n\nПроверете трансмисията\n\nПри автоматична скоростна кутия превключването между режимите трябва да става без силен удар и голямо забавяне. По време на движение смените трябва да са плавни. При ръчна трансмисия проверете дали съединителят отделя нормално, дали скоростите влизат лесно и дали няма приплъзване при ускорение на по-висока предавка.\n\nУсетете спирачките и управлението\n\nНа безопасно място натиснете спирачката по-уверено. Автомобилът трябва да остане стабилен и да не дърпа настрани. Пулсация в педала при обикновено спиране може да означава деформирани дискове. Воланът трябва да се връща естествено след завой, без луфт, вибрации или постоянна корекция по права линия.\n\nМинете по различни настилки\n\nКратък маршрут само по гладък булевард не е достатъчен. Преминете през неравности с ниска скорост и слушайте за тропане или скърцане от окачването. Ако е възможно, включете градско движение и участък с по-висока скорост. Така ще оцените шума в купето, стабилността и работата на асистиращите системи.\n\nПроверете оборудването\n\nИзпробвайте климатика, отоплението, камерите, парктроника, стъклоповдигачите, мултимедията и управлението от волана. Малките електрически дефекти понякога са скъпи за отстраняване. След шофирането отново погледнете таблото и проверете под автомобила за пресни течове.\n\nДобро тестово шофиране продължава достатъчно дълго, за да може автомобилът да достигне работна температура. Ако продавачът отказва разумна проверка или настоява маршрутът да бъде прекалено кратък, приемете това като предупредителен знак.	t	manual-preview	2026-11-23 09:53:10.350488+00	2026-11-23 09:53:10.350505+00	kakvo-da-proverim-po-vreme-na-testovo-shofirane
8	Как да подготвим автомобила за зимата	Зимната подготовка не приключва със смяната на гумите. Проверете акумулатора, течностите, светлините и оборудването преди първия студ.	Ниските температури натоварват акумулатора, двигателя и гумите, а ограничената видимост увеличава риска на пътя. Затова зимната подготовка трябва да се направи преди първия сериозен студ. Повечето проверки са лесни, но могат да предотвратят неприятна повреда в най-неподходящия момент.\n\nИзберете подходящи гуми\n\nЗимните гуми трябва да бъдат в добро състояние и с достатъчна дълбочина на протектора. Проверете възрастта им по маркировката DOT, защото каучукът губи еластичност с времето дори при запазен грайфер. След монтажа измервайте налягането редовно — студеният въздух го понижава. Проверете и резервната гума.\n\nТествайте акумулатора\n\nПри ниска температура капацитетът на акумулатора намалява, а стартирането изисква повече енергия. Ако двигателят завърта бавно, светлините отслабват при стартиране или батерията е стара, направете тест в сервиз. Почистете клемите и проверете дали са затегнати. При автомобили със старт-стоп система използвайте правилния тип акумулатор.\n\nПроверете антифриза\n\nОхлаждащата течност трябва да има подходяща защита от замръзване и да бъде на правилното ниво. Не смесвайте произволни видове антифриз, защото добавките им може да са несъвместими. Ако течността е замърсена или не е сменяна дълго време, следвайте интервала на производителя. Никога не отваряйте системата при горещ двигател.\n\nИзползвайте зимна течност за чистачки\n\nЛятната течност може да замръзне в резервоара и маркучите. Изразходвайте я навреме и я заменете със зимна течност с подходящ температурен диапазон. Огледайте перата на чистачките и ги сменете, ако оставят следи или подскачат. Не ги включвайте, когато са залепнали за стъклото.\n\nОсигурете добра видимост\n\nПроверете всички светлини и почиствайте фаровете редовно. Изправното отопление и обдухване на стъклата са задължителни за бързо премахване на конденза. Дръжте вътрешната страна на стъклата чиста, защото мазният слой усилва заслепяването от насрещните фарове.\n\nПогрижете се за уплътненията и ключалките\n\nПочистете гумените уплътнения на вратите и използвайте подходящ препарат, който ги предпазва от залепване. Не поливайте замръзнала ключалка с гореща вода. Добре е размразителят да бъде в чантата или у дома, а не заключен в автомобила.\n\nПодгответе зимен комплект\n\nНосете стъргалка, четка за сняг, ръкавици, фенер, кабели за подаване на ток и светлоотразителна жилетка. При пътуване извън града добавете одеяло, вода, малка лопата и материал за сцепление. Зареден телефон и външна батерия също могат да бъдат важни при непредвидено спиране.\n\nСлед подготовката адаптирайте и стила си на шофиране. Увеличете дистанцията, работете плавно с волана и педалите и не разчитайте, че електронните системи могат да преодолеят законите на физиката.	t	manual-preview	2026-11-23 09:53:10.356936+00	2026-11-23 09:53:10.356945+00	kak-da-podgotvim-avtomobila-za-zimata
\.


--
-- Data for Name: content_articlegenerationsettings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_articlegenerationsettings (id, prompt, interval_days, is_enabled, last_attempt_at, last_generated_at, last_error, generation_in_progress, generation_started_at) FROM stdin;
1	Напиши полезна и оригинална статия на български език за автомобили. Темата може да е избор и покупка на автомобил, внос от САЩ, поддръжка, безопасност, технологии или пазарни тенденции. Текстът трябва да е практичен, достъпен и подходящ за клиентите на Pan America. Не измисляй конкретни цени, закони или статистики. Не повтаряй темите на последните статии.	7	t	2026-11-23 12:05:45.478421+00	\N	OPENROUTER_API_KEY не е настроен.	f	\N
\.


--
-- Data for Name: content_car; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_car (id, "position", is_active, name, year, price_eur, image, slug, summary, mileage_km, engine, power_hp, fuel, transmission, drivetrain, body_type, color, vin, condition, location, description, features) FROM stdin;
1	0	t	JEEP GRAND CHEROKEE	2017	7000	1.png	jeep-grand-cherokee		\N		\N										
2	1	t	DODGE DURANGO	2018	5500	2.png	dodge-durango		\N		\N										
3	2	t	RAM 1500	2019	8000	3.png	ram-1500		\N		\N										
4	3	t	MERCEDES-BENZ GL	2015	6000	4.png	mercedes-benz-gl		\N		\N										
5	4	t	VOLVO XC60	2019	10500	5.png	volvo-xc60		\N		\N										
6	5	t	AUDI Q5	2019	11000	6.png	audi-q5		\N		\N										
7	6	t	DODGE CHALLENGER	2019	7000	7.png	dodge-challenger		\N		\N										
8	7	t	CHRYSLER PACIFICA	2022	13000	8.png	chrysler-pacifica		\N		\N										
9	8	t	BMW 2 SERIES	2019	12500	9.png	bmw-2-series		\N		\N										
10	9	t	FORD ESCAPE	2022	6500	10.png	ford-escape		\N		\N										
\.


--
-- Data for Name: content_lead; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_lead (id, phone, country, source, created_at) FROM stdin;
\.


--
-- Data for Name: content_review; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_review (id, "position", is_active, name, vehicle, text, image) FROM stdin;
1	0	t	Ola Łuś	LEXUS NX 300H 2018	Искаме със съпруга ми да благодарим на компанията за автомобила на мечтите ми 😍\nАз съм малко труден клиент и невинаги знам какво искам. Съпругът ми обаче е много уравновесен. Директорът на компанията се постара да ни помогне много професионално. Всичко беше ясно и според уговорката. Това ценим много ❤️\nТова не е първият ни автомобил и със сигурност няма да е последният!	car-1.jpg
2	1	t	Anna Bezhutra	Honda Insight 2020	Много съм доволна от услугите на компанията и я препоръчвам на всички, които планират да внесат автомобил от САЩ. Обслужването е на високо ниво, финансовите условия са прозрачни, а доставката е бърза. Препоръчвам ги на всички! Момчетата са истински професионалисти.	car-2.jpg
3	2	t	Krzysztof Łozyński	Honda CIVIC 2019	Благодаря на момчетата за страхотния автомобил! Поехме малък риск, защото нямаше ключове, но който не рискува, не печели. Направиха ключове, монтираха бронята, минаха технически преглед и си тръгнах с колата. Още веднъж благодаря!	car-3.jpg
5	4	t	Michał Koleso	VOLKSWAGEN CC 2.0T R-LINE 2013	Всичко беше просто чудесно: отлично съдействие и крайната цена беше точно тази, за която се бяхме договорили. Благодаря!	car-5.jpg
4	3	t	Adam Rybkin	AUDI Q7 PREMIUM PLUS 2017	Препоръчвам ги на всички. Поръчах автомобил от САЩ за Полша, но в последния момент промених решението си и избрах доставка до Германия. Това не беше никакъв проблем за тях — помогнаха с всичко, от търга до доставката и митническото оформяне. Благодаря за отличното обслужване. Екипът е невероятен и всички помагаха с каквото беше необходимо.	car-4.jpg
6	5	t	Jan Szczerban	Audi A6, Premium Plus 2017	Страхотна компания, която ми осигури пълна подкрепа от избора на автомобил до доставката му до дома ми. Впечатли ме компетентността на мениджърите — отговаряха на всички мои въпроси и ме информираха за всяка стъпка. Автомобилът пристигна навреме и без проблеми. Чудесно!	car-6.jpg
7	6	t	Marek Usomczuk	Ford Expedition 2020	Много професионално обслужване. Взеха предвид всички изисквания. За семейство с две деца има много място. Имах и отделно изискване — голям багажник за превоз на тъщата. Обслужването беше на най-високо ниво. Като търговски представител успях лесно да побера и палет водка. Не искам да урочасам нещата, но съм впечатлен от бързината и качеството.	car-7.jpg
8	7	t	Ola Malinowska	AUDI Q5 PREMIUM PLUS 2018	Благодаря на момчетата — доставиха Q5 в отлично състояние. Специални благодарности на мениджъра Марчин, който отговаряше и денем, и нощем. Много съм доволна от сътрудничеството. Изборът и доставката бяха бързи. Покарахме я известно време, а сега искаме Q7, така че скоро пак ще се свържем!	car-9.jpg
9	8	t	Andrij Kononenko	Nissan Sentra 2017	Много съм благодарен на професионалистите от компанията за тяхната работа. Получих отлична консултация в началото, приятно и конкретно общуване при избора на автомобил, постоянна връзка и актуална информация по време на доставката, както и специална помощ при решаването на индивидуални въпроси. Особени благодарности на мениджъра Олек. Следващия автомобил ще поръчам само от вас!	car-10.jpg
10	9	t	Michał Klimczyk	Audi A4 (B9) 2.0T quattro 2019	Използвах услугите на тази компания и съм много доволен! Професионален подход от самото начало — помогнаха не само с избора и вноса на автомобила, но и с всички формалности, включително регистрацията и митническите документи. След предварителната оферта нямаше скрити такси или допълнителни разходи — всичко беше точно както се бяхме уговорили. Отлична комуникация на всеки етап и винаги бърз и ясен отговор. Силно препоръчвам мениджъра Валдек.	car-11.jpg
11	10	t	Zofia Bazaka	Audi A3 Sportback e-tron (8V), 2018	Искрено препоръчвам Pan America. Благодарение на професионалното обслужване и отдадеността им купих идеалното Audi, което се вижда на снимката. Целият процес протече гладко, а екипът показа компетентност и подкрепа на всяка стъпка. Благодаря за чудесното сътрудничество — препоръчвам ги на всеки, който търси надежден партньор при покупка на автомобил.	car-12.jpg
12	11	t	Paweł	Tesla Model Y Long Range / Performance, 2023	Поръчах Tesla чрез тези момчета — всичко стана бързо, професионално и безупречно. Доставката, обслужването и организацията надминаха очакванията ми. Приятели ме предупреждаваха, че вносът на автомобил от САЩ е дълъг, скъп и сложен процес. Не знам как е при другите компании, но тук всичко беше отлично. Горещо ги препоръчвам! Pan America, страхотни сте!	car-13.jpg
13	12	t	Jan	Dodge Challenger R/T Scat Pack 6.4L HEMI, 2022	Купих автомобил от Pan America, компания за автомобили от САЩ, и съм напълно доволен. Колата е в отлично състояние и струваше наполовина по-малко от подобни оферти в Otomoto. Ремонтът беше евтин, дори по-евтин от очакваното. Горещо препоръчвам Pan America! Вече поръчах и втори автомобил за съпругата си.	car-14.jpg
14	13	t	Julia	BMW X5 xDrive30d (F15), 2017	Искам да благодаря на Pan America за професионалния подбор на автомобил. Всичко беше надеждно, навреме и без допълнителни плащания. Мениджърът беше на разположение денонощно и отговори на всички мои въпроси. Определено препоръчвам!	car-15.jpg
\.


--
-- Data for Name: content_websitesettings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_websitesettings (id, phone, email, address) FROM stdin;
1	+48 579 774 163	hello@panamericaauto.pl	Малинова долина, ул. Еньо Вълчев 2, офис 3
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	content	car
8	content	faq
9	content	lead
10	content	manager
11	content	review
12	content	pagetext
13	content	article
14	content	articlegenerationsettings
15	content	websitesettings
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-11-20 14:17:19.843167+00
2	auth	0001_initial	2026-11-20 14:17:19.893888+00
3	admin	0001_initial	2026-11-20 14:17:19.908943+00
4	admin	0002_logentry_remove_auto_add	2026-11-20 14:17:19.914128+00
5	admin	0003_logentry_add_action_flag_choices	2026-11-20 14:17:19.918063+00
6	contenttypes	0002_remove_content_type_name	2026-11-20 14:17:19.926626+00
7	auth	0002_alter_permission_name_max_length	2026-11-20 14:17:19.931658+00
8	auth	0003_alter_user_email_max_length	2026-11-20 14:17:19.936417+00
9	auth	0004_alter_user_username_opts	2026-11-20 14:17:19.940978+00
10	auth	0005_alter_user_last_login_null	2026-11-20 14:17:19.946435+00
11	auth	0006_require_contenttypes_0002	2026-11-20 14:17:19.947695+00
12	auth	0007_alter_validators_add_error_messages	2026-11-20 14:17:19.952527+00
13	auth	0008_alter_user_username_max_length	2026-11-20 14:17:19.96205+00
14	auth	0009_alter_user_last_name_max_length	2026-11-20 14:17:19.967672+00
15	auth	0010_alter_group_name_max_length	2026-11-20 14:17:19.974859+00
16	auth	0011_update_proxy_permissions	2026-11-20 14:17:19.97889+00
17	auth	0012_alter_user_first_name_max_length	2026-11-20 14:17:19.983765+00
18	content	0001_initial	2026-11-20 14:17:20.003104+00
19	sessions	0001_initial	2026-11-20 14:17:20.011881+00
20	content	0002_localize_seed_bg	2026-11-20 17:03:31.038342+00
21	content	0003_alter_lead_country	2026-11-20 17:07:03.873924+00
22	content	0004_pagetext	2026-11-20 17:10:08.996011+00
23	content	0005_update_service_area	2026-11-23 08:38:10.408311+00
24	content	0006_remove_dynamic_faqs_managers_and_page_texts	2026-11-23 08:57:36.117709+00
25	content	0007_article_and_generation_settings	2026-11-23 09:04:46.96864+00
26	content	0008_website_settings	2026-11-23 09:08:48.020232+00
27	content	0009_article_slug	2026-11-23 09:36:11.492671+00
28	content	0010_car_detail_fields	2026-11-23 11:05:26.730152+00
29	content	0011_update_website_address	2026-11-23 11:51:59.15952+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
fipbiji9bot9uiiujtrydfbxn4jppoc0	.eJxVjMsOwiAUBf-FtSE8agGX7vsN5D5AqgaS0q6M_65NutDtmZnzEhG2tcStpyXOLC7CiNPvhkCPVHfAd6i3JqnVdZlR7oo8aJdT4_S8Hu7fQYFevjU5smTP5BKSt-yNCp6DRww-DJkVjs5pjRozZZ0UgUGwitGhGgdlQLw__Ew4gg:1xVPgT:yrZIP53xYttpb5a2J5Zbf38OAi4G6tG2nMDxrVyOi8M	2026-12-07 08:45:57.666041+00
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 60, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 2, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: content_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_article_id_seq', 9, true);


--
-- Name: content_articlegenerationsettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_articlegenerationsettings_id_seq', 1, false);


--
-- Name: content_car_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_car_id_seq', 11, true);


--
-- Name: content_lead_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_lead_id_seq', 1, true);


--
-- Name: content_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_review_id_seq', 14, true);


--
-- Name: content_websitesettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_websitesettings_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 15, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 29, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: content_article content_article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_article
    ADD CONSTRAINT content_article_pkey PRIMARY KEY (id);


--
-- Name: content_article content_article_slug_d023fc80_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_article
    ADD CONSTRAINT content_article_slug_d023fc80_uniq UNIQUE (slug);


--
-- Name: content_articlegenerationsettings content_articlegenerationsettings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_articlegenerationsettings
    ADD CONSTRAINT content_articlegenerationsettings_pkey PRIMARY KEY (id);


--
-- Name: content_car content_car_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_car
    ADD CONSTRAINT content_car_pkey PRIMARY KEY (id);


--
-- Name: content_car content_car_slug_cca5d446_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_car
    ADD CONSTRAINT content_car_slug_cca5d446_uniq UNIQUE (slug);


--
-- Name: content_lead content_lead_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_lead
    ADD CONSTRAINT content_lead_pkey PRIMARY KEY (id);


--
-- Name: content_review content_review_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_review
    ADD CONSTRAINT content_review_pkey PRIMARY KEY (id);


--
-- Name: content_websitesettings content_websitesettings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_websitesettings
    ADD CONSTRAINT content_websitesettings_pkey PRIMARY KEY (id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: content_article_slug_d023fc80_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX content_article_slug_d023fc80_like ON public.content_article USING btree (slug varchar_pattern_ops);


--
-- Name: content_car_slug_cca5d446_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX content_car_slug_cca5d446_like ON public.content_car USING btree (slug varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\unrestrict 5UswzotgvGX1OFkNOfLMpvLC4eILzrsEoQXy8EzQzseMVzrbM6Kk17JS0TerqWd

