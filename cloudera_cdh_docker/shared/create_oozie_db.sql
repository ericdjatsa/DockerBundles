CREATE ROLE oozie LOGIN ENCRYPTED PASSWORD 'oozie' 
 NOSUPERUSER INHERIT CREATEDB NOCREATEROLE;

CREATE DATABASE "oozie" WITH OWNER = oozie
 ENCODING = 'UTF8'
 TABLESPACE = pg_default
 LC_COLLATE = 'en_US.UTF8'
 LC_CTYPE = 'en_US.UTF8'
 CONNECTION LIMIT = -1;
