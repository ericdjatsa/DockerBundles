FROM eric.djatsa/cdh5hadoopmaster

# The parameter below will be used by my custom build script 
# In order to automate the rebuild of all my docker images
#IMAGE_BUILD_TAG=eric.djatsa/cdh5hadoopmaster_oozie

MAINTAINER Eric Djatsa , djatsaedy@gmail.com

# Install Oozie server and oozie client
# Also install PostreSQL to be used as Oozie DB
# Instructions here : http://www.cloudera.com/content/cloudera/en/documentation/core/v5-2-x/topics/cdh_ig_oozie_installation.html
RUN apt-get update && apt-get install -y -q --force-yes \
	oozie \
	oozie-client \
	postgresql=9.1+129ubuntu1 \
	postgresql-contrib=9.1+129ubuntu1

# Set a shell for the 'oozie' user so that he can execute commands
RUN chsh -s /bin/sh oozie

# Copy oozie db creation script
COPY create_oozie_db.sql /opt/create_oozie_db.sql

# Start postgres server and create oozie database

RUN su postgres -c "/etc/init.d/postgresql start && psql -a -f /opt/create_oozie_db.sql"

# Configure which hadoop version to use in Oozie ( Yarn or MR1 : in our case we use Yarn )
RUN su -c " update-alternatives --set oozie-tomcat-conf /etc/oozie/tomcat-conf.http"

# configure the Oozie server to work with YARN instead of default MRv1
# see http://www.cloudera.com/content/cloudera/en/documentation/cdh4/v4-2-1/CDH4-Installation-Guide/cdh4ig_topic_17_6.html
ENV CATALINA_BASE /usr/lib/oozie/oozie-server


# Copy oozie-site.xml to Oozie conf dir
COPY shared/oozie-site.xml /etc/oozie/conf/

# Set Oozie URL
ENV OOZIE_URL http://localhost:11000/oozie

# Save OOZIE_URL in ~/.bashrc in order to simplify oozie command line usage
RUN echo 'export OOZIE_URL=http://localhost:11000/oozie' >> ~/.bashrc

# Configure Postgres to accept network connections for user oozie .
RUN echo "host    oozie         oozie         0.0.0.0/0             md5" >> /etc/postgresql/9.1/main/pg_hba.conf


# Reload the Postgres configuration.
# Usage: /usr/bin/pg_ctlcluster <version> <cluster> <action>

# Then create the oozie DB Schema (NB : we need to perform this operation as oozie user)
RUN su postgres -c "pg_ctlcluster 9.1 main restart " &&  su oozie -c "/usr/lib/oozie/bin/ooziedb.sh create -run" 

# Configure Oozie webconsole ( copy web console libs ) 
RUN mkdir -p /var/lib/oozie/
COPY Libs/ext-2.2.zip /var/lib/oozie/
RUN cd /var/lib/oozie && unzip /var/lib/oozie/ext-2.2.zip && chmod -R 1777 /var/lib/oozie

#Set OOZIE_URL parameter
#By default, Oozie server runs on port 11000 and its URL is http://<OOZIE_HOSTNAME>:11000/oozie
ENV OOZIE_URL http://localhost:11000/oozie

# Expose postgres default port
EXPOSE 5432 

# Expose Oozie port
EXPOSE 11000
 
COPY master_oozie_startup.sh /opt/startup/
RUN chmod +x /opt/startup/master_oozie_startup.sh

# Finally execute startup script and handle over to ssh
CMD /opt/startup/master_oozie_startup.sh && /usr/sbin/sshd -D