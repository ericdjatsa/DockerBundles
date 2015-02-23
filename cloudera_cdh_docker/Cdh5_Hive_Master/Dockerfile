FROM eric.djatsa/cdh5hadoopmaster

# CONTAINER IMAGE tag will be : eric.djatsa/cdh5hadoopmaster_hive
MAINTAINER Eric Djatsa , djatsaedy@gmail.com

# Install Hive components 
RUN apt-get update && apt-get install -q -y --force-yes hive \
	hive-metastore \
	hive-server2 && \
	rm -f /var/lib/hive/metastore/metastore_db/dbex.lck


COPY master_hive_startup.sh /opt/startup/
RUN chmod +x /opt/startup/master_hive_startup.sh

# Finally execute startup script and handle over to ssh
CMD /opt/startup/master_hive_startup.sh && /usr/sbin/sshd -D