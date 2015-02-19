CREATE ROLE oozie LOGIN ENCRYPTED PASSWORD 'oozie' 
 NOSUPERUSER INHERIT CREATEDB NOCREATEROLE;

CREATE DATABASE "oozie" WITH OWNER = oozie
 ENCODING = 'UTF8'
 TABLESPACE = pg_global
 LC_COLLATE = 'en_US.UTF8'
 LC_CTYPE = 'en_US.UTF8'
 CONNECTION LIMIT = -1;



RUN apt-get install -y --force-yes \
	mysql-server=5.5.41-0ubuntu0.12.04.1

# We set the mysql "root" user's password to 'root' 
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections 

echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections" 



su postgres -c " psql postgres -d pg_default -a -f ~/create_oozie_db.sql" 

su postgres -c " psql postgres"

sudo -u postgres pg_ctl reload -s -D /etc/postgresql/9.1/main


# List databases
postgres # \list

# list tables spaces
select * from pg_tables