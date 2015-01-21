FROM pti1/hadoopmaster:v3

MAINTAINER PTI PTI, pti@coco.fr

#
# Add necessary repos for installation
# http://doc.mapr.com/display/MapR/Installing+MapR+Software#InstallingMapRSoftware-mapr_repo
#


ADD proxy.sh /opt/docker_common_scripts/0_proxy.sh
ADD nsupdate.sh /opt/docker_common_scripts/1_proxy.sh
RUN /opt/docker_common_scripts/0_proxy.sh

RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -

RUN apt-get update 
RUN apt-get install -q -y --force-yes spark-core spark-master spark-worker spark-history-server spark-python scala

RUN apt-get install -q -y --force-yes hive hive-metastore hive-server2 && \
    rm -f /var/lib/hive/metastore/metastore_db/dbex.lck


ADD utils.sh /usr/lib/spark/bin/
ADD spark-env.sh /etc/spark/conf/

# Install Oozie server
# Instructions here : http://www.cloudera.com/content/cloudera/en/documentation/core/v5-2-x/topics/cdh_ig_oozie_installation.html
RUN apt-get install -y --force-yes oozie

# Install oozie client
RUN apt-get install -y --force-yes oozie-client

# Configure which hadoop version to use ( Yarn or MR1 : in our case we use Yarn )
RUN su -c " update-alternatives --set oozie-tomcat-conf /etc/oozie/tomcat-conf.http"

# Configure Oozie webconsole
RUN mkdir /var/lib/oozie/ext-2.2
COPY Libs/ext-2.2 /var/lib/oozie/ext-2.2


ADD startup.sh /opt/
CMD ["/opt/startup.sh"]

