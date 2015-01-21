FROM ubuntu:12.04

MAINTAINER Eric Djatsa , djatsaedy@gmail.com

#
# Add necessary repos for installation
# http://doc.mapr.com/display/MapR/Installing+MapR+Software#InstallingMapRSoftware-mapr_repo
#

ENV DEBIAN_FRONTEND noninteractive
# The line below is to solve an issue with Docker's ubuntu which includes a policy-rc.d file that simply returns 101 (not allowed) for any service that tries to start/restart after installation
# See http://monkinetic.com/2014/07/25/docker-openstack-policy-rcd-mysqld
RUN echo "#!/bin/sh" > /usr/sbin/policy-rc.d && echo "exit 0" >> /usr/sbin/policy-rc.d

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

COPY shared/proxy.sh /opt/docker_common_scripts/0_proxy.sh
COPY shared/nsupdate.sh /opt/docker_common_scripts/1_proxy.sh

# TODO : below command fails with error : 
# /bin/sh: 1: /opt/docker_common_scripts/0_proxy.sh: Permission denied
#RUN /opt/docker_common_scripts/0_proxy.sh

RUN apt-get update 
RUN apt-get install -q -y --force-yes wget curl inetutils-ping telnet net-tools vim htop dnsutils apt-utils unzip ruby


# install java
RUN apt-get install -y openjdk-7-jdk
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64


# THIS IS TO GET SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd

# HADOOP INSTALL
#add CDH repo
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/cloudera.list > /etc/apt/sources.list.d/cloudera.list

 
# Add CM( Cloudera Manager ) repo 
RUN curl http://archive.cloudera.com/cm5/ubuntu/precise/amd64/cm/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cm5/ubuntu/precise/amd64/cm/cloudera.list > /etc/apt/sources.list.d/cloudera-manager.list

RUN apt-get update

RUN apt-get install -q -y --force-yes hadoop-yarn-resourcemanager hadoop-hdfs-namenode 
RUN apt-get install -q -y --force-yes hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce 

COPY shared/core-site.xml /etc/hadoop/conf.empty/
COPY shared/yarn-site.xml /etc/hadoop/conf.empty/
COPY shared/mapred-site.xml /etc/hadoop/conf.empty/
COPY shared/hdfs-site.xml /etc/hadoop/conf.empty/

# TODO : Assign correct permissions to the hadoop conf directory
RUN chmod -R 1777 /etc/hadoop/conf.empty/

# Install Oozie server
# Instructions here : http://www.cloudera.com/content/cloudera/en/documentation/core/v5-2-x/topics/cdh_ig_oozie_installation.html
#RUN apt-get install -y --force-yes oozie

# Install oozie client
#RUN apt-get install -y --force-yes oozie-client

# Configure which hadoop version to use in Oozie ( Yarn or MR1 : in our case we use Yarn )
#RUN su -c " update-alternatives --set oozie-tomcat-conf /etc/oozie/tomcat-conf.http"

# Configure Oozie webconsole ( copy web console libs ) 
#RUN mkdir /var/lib/oozie/
##COPY Libs/ext-2.2.zip /var/lib/oozie/
##RUN cd /var/lib/oozie && unzip /var/lib/oozie/ext-2.2.zip

# Set Oozie web console URL
ENV OOZIE_URL http://localhost:11000/oozie

# Create name dir ( as specified in hdfs-site.xml )
RUN su hdfs -c "mkdir -p /var/lib/hadoop-hdfs/hdfs/name"

# Format HDFS (NB : this operation should be performed as user hdfs)
RUN su hdfs -c "hdfs namenode -format"

# TODO : After formatting hdfs, assign correct permissions to namenode directory
#RUN chmod -R 1777 /var/lib/hadoop-hdfs/cache/hdfs/dfs/name

EXPOSE 7180 7183 7182 7432 50020 50070 50010 50075 8040 8042 47314 13562 8030 8031 46664 57299 53686 50176 38904
EXPOSE 1004 1006 8020 50470 50090 50495 8485 8480 8032 8033 8088 8041 10020 19888 22 9160 9042
# Expose Oozie port
EXPOSE 11000

COPY startup.sh /opt/

RUN chmod +x /opt/startup.sh

CMD ["/opt/startup.sh"]

