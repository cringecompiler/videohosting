CREATE SCHEMA videosharing_project
    AUTHORIZATION postgres;

--установим search_path
set search_path to 'videosharing_project';

--создадим последовательности для PK
CREATE SEQUENCE videosharing_project.basic_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."User_id_User_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."Gender_id_Gender_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

CREATE SEQUENCE videosharing_project."Service_subscription_id_Service_subscription_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."Playlist_id_Playlist_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."Video_id_Video_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."Comment_id_Comment_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."Genre_id_Genre_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."Age_restriction_id_Age_restriction_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE SEQUENCE videosharing_project."Ad_id_Ad_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
--создадим таблицы для всех сущностей
--таблица Gender
CREATE TABLE IF NOT EXISTS videosharing_project."Gender"
(
    "id_Gender" integer NOT NULL DEFAULT nextval('videosharing_project."Gender_id_Gender_seq"'::regclass),
    name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Gender_pkey" PRIMARY KEY ("id_Gender")
)


--таблица Service_subscription
CREATE TABLE IF NOT EXISTS videosharing_project."Service_subscription"
(
    "id_Service_subscription" integer NOT NULL DEFAULT nextval('videosharing_project."Service_subscription_id_Service_subscription_seq"'::regclass),
    name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    price integer NOT NULL,
    duration_days integer NOT NULL,
    functions character varying[] COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Service_subscription_pkey" PRIMARY KEY ("id_Service_subscription")
)

--таблица User
CREATE TABLE IF NOT EXISTS videosharing_project."User"
(
    "id_User" integer NOT NULL DEFAULT nextval('videosharing_project."User_id_User_seq"'::regclass),
    mail character varying(45) COLLATE pg_catalog."default" NOT NULL,
    birthday date,
    "id_Gender" integer NOT NULL,
    nickname character varying(45) COLLATE pg_catalog."default" NOT NULL,
    "id_Service_subscription" integer NOT NULL,
    CONSTRAINT "User_pkey" PRIMARY KEY ("id_User"),
    CONSTRAINT "User_id_Gender_fkey" FOREIGN KEY ("id_Gender")
        REFERENCES videosharing_project."Gender" ("id_Gender") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "User_id_Service_subscription_fkey" FOREIGN KEY ("id_Service_subscription")
        REFERENCES videosharing_project."Service_subscription" ("id_Service_subscription") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

--таблица Сhannel
CREATE TABLE IF NOT EXISTS videosharing_project."Channel"
(
    "id_Channel" integer NOT NULL DEFAULT nextval('videosharing_project.basic_seq'::regclass),
    "id_Creator" integer NOT NULL,
    name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    date_of_creation date NOT NULL,
    views bigint,
    description text COLLATE pg_catalog."default",
    CONSTRAINT "Channel_pkey" PRIMARY KEY ("id_Channel"),
    CONSTRAINT "Channel_id_Creator_fkey" FOREIGN KEY ("id_Creator")
        REFERENCES videosharing_project."User" ("id_User") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)


--таблица Playlist
CREATE TABLE IF NOT EXISTS videosharing_project."Playlist"
(
    "id_Playlist" integer NOT NULL DEFAULT nextval('videosharing_project."Playlist_id_Playlist_seq"'::regclass),
    name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    "id_User" integer NOT NULL,
    "id_Channel" integer NOT NULL,
    CONSTRAINT "Playlist_pkey" PRIMARY KEY ("id_Playlist"),
    CONSTRAINT "Playlist_id_Channel_fkey" FOREIGN KEY ("id_Channel")
        REFERENCES videosharing_project."Channel" ("id_Channel") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Playlist_id_User_fkey" FOREIGN KEY ("id_User")
        REFERENCES videosharing_project."User" ("id_User") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

--таблица Subscriptions
CREATE TABLE IF NOT EXISTS videosharing_project."Subscriptions"
(
    "id_User" integer NOT NULL,
    "id_Channel" integer NOT NULL,
    CONSTRAINT "Subscriptions_id_Channel_fkey" FOREIGN KEY ("id_Channel")
        REFERENCES videosharing_project."Channel" ("id_Channel") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Subscriptions_id_User_fkey" FOREIGN KEY ("id_User")
        REFERENCES videosharing_project."User" ("id_User") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

--таблица Genre
CREATE TABLE IF NOT EXISTS videosharing_project."Genre"
(
    "id_Genre" integer NOT NULL DEFAULT nextval('videosharing_project."Genre_id_Genre_seq"'::regclass),
    name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT "Genre_pkey" PRIMARY KEY ("id_Genre")
)

--таблица Age_restriction
CREATE TABLE IF NOT EXISTS videosharing_project."Age_restriction"
(
    "id_Age_restriction" integer NOT NULL DEFAULT nextval('videosharing_project."Age_restriction_id_Age_restriction_seq"'::regclass),
    min_age integer NOT NULL,
    name_restriction character varying(10) COLLATE pg_catalog."default",
    CONSTRAINT "Age_restriction_pkey" PRIMARY KEY ("id_Age_restriction")
)


--таблица Video
CREATE TABLE IF NOT EXISTS videosharing_project."Video"
(
    "id_Video" integer NOT NULL DEFAULT nextval('videosharing_project."Video_id_Video_seq"'::regclass),
    name character varying(45) COLLATE pg_catalog."default" NOT NULL,
    "id_Channel" integer NOT NULL,
    publication_date_time timestamp with time zone,
    description text COLLATE pg_catalog."default",
    likes bigint,
    dislikes bigint,
    duration_sec integer NOT NULL,
    "id_Age_restriction" integer,
    CONSTRAINT "Video_pkey" PRIMARY KEY ("id_Video"),
    CONSTRAINT "Video_id_Age_restriction_fkey" FOREIGN KEY ("id_Age_restriction")
        REFERENCES videosharing_project."Age_restriction" ("id_Age_restriction") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT "Video_id_Channel_fkey" FOREIGN KEY ("id_Channel")
        REFERENCES videosharing_project."Channel" ("id_Channel") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

--таблица Comment
CREATE TABLE IF NOT EXISTS videosharing_project."Comment"
(
    "id_Comment" integer NOT NULL DEFAULT nextval('videosharing_project."Comment_id_Comment_seq"'::regclass),
    "id_Video" integer NOT NULL,
    "id_User" integer NOT NULL,
    content text COLLATE pg_catalog."default" NOT NULL,
    date_pub timestamp with time zone,
    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id_Comment"),
    CONSTRAINT "Comment_id_User_fkey" FOREIGN KEY ("id_User")
        REFERENCES videosharing_project."User" ("id_User") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Comment_id_Video_fkey" FOREIGN KEY ("id_Video")
        REFERENCES videosharing_project."Video" ("id_Video") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)


--таблица Video_genre
CREATE TABLE IF NOT EXISTS videosharing_project."Video_genre"
(
    "id_Video" integer NOT NULL,
    "id_Genre" integer NOT NULL,
    CONSTRAINT "Video_ genre_id_Genre_fkey" FOREIGN KEY ("id_Genre")
        REFERENCES videosharing_project."Genre" ("id_Genre") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT "Video_ genre_id_Video_fkey" FOREIGN KEY ("id_Video")
        REFERENCES videosharing_project."Video" ("id_Video") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)


--таблица Playlist_has_Video
CREATE TABLE IF NOT EXISTS videosharing_project."Playlist_has_Video"
(
    "id_Playlist" integer NOT NULL,
    "id_Video" integer NOT NULL,
    CONSTRAINT "Playlist_has_Video_id_Playlist_fkey" FOREIGN KEY ("id_Playlist")
        REFERENCES videosharing_project."Playlist" ("id_Playlist") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT "Playlist_has_Video_id_Video_fkey" FOREIGN KEY ("id_Video")
        REFERENCES videosharing_project."Video" ("id_Video") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

--таблица Ad
CREATE TABLE IF NOT EXISTS videosharing_project."Ad"
(
    "id_Ad" integer NOT NULL DEFAULT nextval('videosharing_project."Ad_id_Ad_seq"'::regclass),
    company_name character varying(45) COLLATE pg_catalog."default",
    "id_Age_restriction" integer,
    lenght_sec integer,
	end_show_date timestamp with time zone,
    payment_method character varying(20) COLLATE pg_catalog."default",
    CONSTRAINT "Ad_pkey" PRIMARY KEY ("id_Ad"),
    CONSTRAINT "Ad_id_Age_restriction_fkey" FOREIGN KEY ("id_Age_restriction")
        REFERENCES videosharing_project."Age_restriction" ("id_Age_restriction") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

--таблица Ad_User
CREATE TABLE IF NOT EXISTS videosharing_project."Ad_user"
(
    "id_Ad" integer NOT NULL,
    "id_User" integer NOT NULL,
    CONSTRAINT "Ad_user_id_Ad_fkey" FOREIGN KEY ("id_Ad")
        REFERENCES videosharing_project."Ad" ("id_Ad") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT "Ad_user_id_User_fkey" FOREIGN KEY ("id_User")
        REFERENCES videosharing_project."User" ("id_User") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

--таблица Ad_video
CREATE TABLE IF NOT EXISTS videosharing_project."Ad_video"
(
    "id_Ad" integer NOT NULL,
    "id_Video" integer NOT NULL,
    CONSTRAINT "Ad_video_id_Ad_fkey" FOREIGN KEY ("id_Ad")
        REFERENCES videosharing_project."Ad" ("id_Ad") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT "Ad_video_id_Video_fkey" FOREIGN KEY ("id_Video")
        REFERENCES videosharing_project."Video" ("id_Video") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

--выполним запросы на вставку данных различными способами
INSERT INTO "Genre" ("name")
VALUES ('anime'),
('sport'), ('thriller'), ('music'), ('politics'), ('gaming'), ('lifestyle');

INSERT INTO "Age_restriction" (min_age, name_restriction)
VALUES (0, 'G'), (13, 'PG-13'), (18, 'R');

INSERT INTO "Gender" ("name")
VALUES ('female'), ('nonbinary'), ('male');

INSERT INTO "Service_subscription" ("name", price, duration_days, "functions")
VALUES ('basic', 0, 31, '{"watch", "subscribe"}');

INSERT INTO "Service_subscription" ("name", price, duration_days, "functions")
VALUES ('pro', 20, 31, '{"watch", "subscribe", "download", "no_adds"}');

INSERT INTO "Ad" (company_name, "id_Age_restriction", lenght_sec, end_show_date, payment_method)
Select 'company_'::character varying || n::character varying, 
		 (random()*2 + 1)::integer, 
		 (random()*200 + 1)::integer,  
		 current_date + round(random() * 30)*interval'1 day',
		 'debit card'
		 from generate_series(1, 50) as src(n);

INSERT INTO "User" (mail, birthday, "id_Gender", nickname, "id_Service_subscription")
Select md5(random()::text) || '@yandex.ru', 
		 current_date - round(random() * 15000)*interval'1 day', 
		 (random()*2 + 1)::integer,  
		 'nickname_'::character varying || n::character varying,
		 (random() + 1)::integer
		 from generate_series(1, 1000) as src(n);

INSERT INTO "Channel" ("id_Creator", "name", date_of_creation, "views", description)
Select n, 
		 'name_'::character varying || n::character varying, 
		 current_date - round(random() * 100)*interval'1 day',  
		 (random()*100000)::integer,
		 'hello friends'
		 from generate_series(1, 500) as src(n);
		 
INSERT INTO "Subscriptions" ("id_User", "id_Channel")
Select	 (random()*999 + 1)::integer,
		 (random()*499 + 1)::integer
		 from generate_series(1, 50000) as src(n);
		 
INSERT INTO "Video" ("name", "id_Channel", publication_date_time, description, likes, dislikes, duration_sec, "id_Age_restriction")
Select	 'video_name_'::character varying || n::character varying,
		 (random()*499 + 1)::integer,
		 current_date - round(random() * 50)*interval'1 day',
		 'press thumbs up and leave likes and comments below',
		 (random()*1000)::integer,
		 (random()*100)::integer,
		 (random()*300)::integer,
		 (random()*2 + 1)::integer
		 from generate_series(1, 500) as src(n);
		 
INSERT INTO "Ad_video" ("id_Ad", "id_Video")
Select	(random()*49 + 1)::integer,
		(random()*499 + 1)::integer
		from generate_series(1, 1000) as src(n);

INSERT INTO "Playlist"("name", description, "id_User", "id_Channel")
Select	'playlist_name_'::character varying || n::character varying,
		'cozy noise of a big city',
		(random()*999 + 1)::integer,
		(random()*499 + 1)::integer
		from generate_series(1, 1000) as src(n);
		
INSERT INTO "Video_genre"("id_Video", "id_Genre")
Select	 (random()*499 + 1)::integer,
		 (random()*6 + 1)::integer
		 from generate_series(1, 10000) as src(n);

INSERT INTO "Comment"("id_Video", "id_User", "content", date_pub)
Select	 (random()*499 + 1)::integer,
		 (random()*999 + 1)::integer,
		 md5(random()::text),
		 current_date - round(random() * 30)*interval'1 day' 
		 from generate_series(1, 1000000) as src(n);

INSERT INTO "Playlist_has_Video"("id_Playlist", "id_Video")
Select	 (random()*999 + 1)::integer,
		 (random()*499 + 1)::integer
		 from generate_series(1, 10000) as src(n);

INSERT INTO "Ad_user"("id_Ad", "id_User")
Select	 (random()*49 + 1)::integer,
		 (random()*999 + 1)::integer
		 from generate_series(1, 20000) as src(n);
		 
--количество видео в каждом жанре		 
select "name", count("id_Video") 
from "Video_genre" join "Genre" on "Genre"."id_Genre"="Video_genre"."id_Genre"
group by "name";

--среднее число подписок на каналы одного пользователя
select round(avg(cnt), 2) from
(select count("id_User") as cnt
from "Subscriptions"
group by "id_User") ad



