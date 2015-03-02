FROM eric.djatsa/ubuntu_12_04
# CONTAINER IMAGE tag will be : eric.djatsa/cdh5hadoopmaster
MAINTAINER Eric Djatsa , djatsaedy@gmail.com

#
# TODO : create Dockerfile with MapR repositories
# http://doc.mapr.com/display/MapR/Installing+MapR+Software#InstallingMapRSoftware-mapr_repo
#


# HADOOP INSTALL
#add CDH repo
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/cloudera.list > /etc/apt/sources.list.d/cloudera.list

 
# Add CM( Cloudera Manager ) repo 
RUN curl http://archive.cloudera.com/cm5/ubuntu/precise/amd64/cm/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cm5/ubuntu/precise/amd64/cm/cloudera.list > /etc/apt/sources.list.d/cloudera-manager.list

RUN apt-get update && apt-get install -q -y --force-yes \
	hadoop-yarn-resourcemanager \
	hadoop-hdfs-namenode \
	hadoop-yarn-nodemanager \
	hadoop-hdfs-datanode \
	hadoop-mapreduce

COPY shared/core-site.xml /etc/hadoop/conf.empty/
COPY shared/yarn-site.xml /etc/hadoop/conf.empty/
COPY shared/mapred-site.xml /etc/hadoop/conf.empty/
COPY shared/hdfs-site.xml /etc/hadoop/conf.empty/

# TODO : Assign correct permissions to the hadoop conf directory
RUN chmod -R 1777 /etc/hadoop/conf.empty/

# Create name dir ( as specified in hdfs-site.xml )
RUN su hdfs -c "mkdir -p /var/lib/hadoop-hdfs/hdfs/name"

# Format HDFS (NB : this operation should be performed as user hdfs)
RUN su hdfs -c "hdfs namenode -format"

# Expose a set of Hadoop ports
EXPOSE 7180 7183 7182 7432 50020 50070 50010 50075 8040 8042 47314 13562 8030 8031 46664 57299 53686 50176 38904
EXPOSE 1004 1006 8020 50470 50090 50495 8485 8480 8032 8033 8088 8041 10020 19888 22 9160 9042

# The proxy.sh file is needed only if in your environment, you need to access to Internet through a proxy
# In that case you will have to set the proper values in the proxy.sh file 
#COPY shared/proxy.sh /opt/docker_common_scripts/0_proxy.sh
COPY shared/nsupdate.sh /opt/docker_common_scripts/1_nsupdate.sh

#RUN chmod +x /opt/docker_common_scripts/0_proxy.sh
RUN chmod +x /opt/docker_common_scripts/1_nsupdate.sh

RUN echo "Adding master_startup.sh"
COPY master_startup.sh /opt/startup/master_startup.sh

RUN chmod +x /opt/startup/master_startup.sh

# Finally execute startup script and handle over to ssh
CMD /opt/startup/master_startup.sh && /usr/sbin/sshd -D
