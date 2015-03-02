FROM eric.djatsa/ubuntu_12_04
# CONTAINER IMAGE tag will be : eric.djatsa/cdh5hadoopslave

MAINTAINER Eric Djatsa , djatsaedy@gmail.com

# hadoop slave install
#add CDH repo
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/cloudera.list > /etc/apt/sources.list.d/cloudera.list


RUN apt-get update && apt-get install -q -y --force-yes hadoop-yarn-nodemanager \
	hadoop-hdfs-datanode \
	hadoop-mapreduce \
	hadoop-client

COPY shared/core-site.xml /etc/hadoop/conf.empty/
COPY shared/yarn-site.xml /etc/hadoop/conf.empty/
COPY shared/mapred-site.xml /etc/hadoop/conf.empty/
COPY shared/hdfs-site.xml /etc/hadoop/conf.empty/

# Create data dir ( as specified in hdfs-site.xml )
RUN su hdfs -c "mkdir -p /var/lib/hadoop-hdfs/hdfs/data"

# Expose a bunch of Hadoop ports
EXPOSE 7180 7183 7182 7432 50020 50070 50010 50075 8040 8042 47314 13562 8030 8031 46664 57299 53686 50176 38904

EXPOSE 1004 1006 8020 50470 50090 50495 8485 8480 8032 8033 8088 8041 10020 19888 9160 9042 22

# The proxy.sh file is needed only if in your environment, you need to access to Internet through a proxy
# In that case you will have to set the proper values in the proxy.sh file 
#COPY shared/proxy.sh /opt/docker_common_scripts/0_proxy.sh
COPY shared/nsupdate.sh /opt/docker_common_scripts/1_nsupdate.sh

#RUN chmod +x /opt/docker_common_scripts/0_proxy.sh
RUN chmod +x /opt/docker_common_scripts/1_nsupdate.sh

COPY slave_startup.sh /opt/startup/slave_startup.sh

RUN chmod +x /opt/startup/slave_startup.sh

# Finally execute startup script and handle over to ssh
CMD /opt/startup/slave_startup.sh && /usr/sbin/sshd -D
