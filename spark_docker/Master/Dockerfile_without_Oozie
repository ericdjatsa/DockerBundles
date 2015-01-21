FROM pti1/hadoopmaster:secondversion

MAINTAINER PTI PTI, pti@coco.fr

#
# Add necessary repos for installation
# http://doc.mapr.com/display/MapR/Installing+MapR+Software#InstallingMapRSoftware-mapr_repo
#


ADD proxy.sh /opt/docker_common_scripts/0_proxy.sh
ADD nsupdate.sh /opt/docker_common_scripts/1_proxy.sh
RUN /opt/docker_common_scripts/0_proxy.sh

RUN apt-get update 
RUN apt-get install -q -y --force-yes spark-core spark-master spark-worker spark-history-server spark-python scala

RUN apt-get install -q -y --force-yes hive hive-metastore hive-server2 && \
    rm -f /var/lib/hive/metastore/metastore_db/dbex.lck


ADD utils.sh /usr/lib/spark/bin/
ADD spark-env.sh /etc/spark/conf/

ADD startup.sh /opt/
CMD ["/opt/startup.sh"]

