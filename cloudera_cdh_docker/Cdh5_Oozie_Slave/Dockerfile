FROM eric.djatsa/cdh5hadoopslave
# CONTAINER IMAGE tag will be : eric.djatsa/cdh5hadoopslave_oozie

MAINTAINER Eric Djatsa , djatsaedy@gmail.com

# Install oozie client
RUN apt-get update && apt-get install -y -q --force-yes oozie-client

# Copy oozie-site.xml to Oozie conf dir
COPY shared/oozie-site.xml /etc/oozie/conf/

# Set Oozie URL
# The the master container (the one running OOzie server - eric.djatsa/cdh5hadoopmaster_oozie ) should be linked
# to this slave container using the name 'master' 
ENV OOZIE_URL http://master:11000/oozie

COPY slave_oozie_startup.sh /opt/startup/slave_oozie_startup.sh

RUN chmod +x /opt/startup/slave_oozie_startup.sh

# Finally execute startup script and handle over to ssh
CMD /opt/startup/slave_oozie_startup.sh && /usr/sbin/sshd -D


 
