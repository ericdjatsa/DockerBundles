FROM eric.djatsa/cdh5hadoopslave
# CONTAINER IMAGE tag will be : eric.djatsa/cdh5hadoopslave_hive

MAINTAINER Eric Djatsa , djatsaedy@gmail.com

# Install hive 
RUN apt-get update && apt-get install -q -y --force-yes hive

COPY slave_hive_startup.sh /opt/startup/slave_hive_startup.sh

RUN chmod +x /opt/startup/slave_hive_startup.sh

# Finally execute startup script and handle over to ssh
CMD /opt/startup/slave_hive_startup.sh && /usr/sbin/sshd -D


 
