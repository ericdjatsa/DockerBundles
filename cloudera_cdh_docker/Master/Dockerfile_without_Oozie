FROM ubuntu:12.04

MAINTAINER PTI PTI, pti@coco.fr

#
# Add necessary repos for installation
# http://doc.mapr.com/display/MapR/Installing+MapR+Software#InstallingMapRSoftware-mapr_repo
#

ENV DEBIAN_FRONTEND noninteractive
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

ADD proxy.sh /opt/docker_common_scripts/0_proxy.sh
ADD nsupdate.sh /opt/docker_common_scripts/1_proxy.sh
RUN /opt/docker_common_scripts/0_proxy.sh

RUN apt-get update 
RUN apt-get install -q -y --force-yes wget curl inetutils-ping telnet net-tools vim htop dnsutils apt-utils ruby


# install java
# Install Java.
RUN apt-get install -y openjdk-7-jdk
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64


# THIS IS TO GET SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd

# HADOOP INSTALL
RUN echo "deb [arch=amd64] http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh precise-cdh5 contrib" > /etc/apt/sources.list.d/cloudera.list

RUN echo "deb-src http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh precise-cdh5 contrib" >> /etc/apt/sources.list.d/clouderasrc.list

RUN echo "curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -"

RUN apt-get update

RUN apt-get install -q -y --force-yes hadoop-yarn-resourcemanager hadoop-hdfs-namenode 
RUN apt-get install -q -y --force-yes hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce


ADD core-site.xml /etc/hadoop/conf.empty/
ADD startup.sh /opt/

RUN su -c "hdfs namenode -format" hdfs

CMD ["/opt/startup.sh"]

EXPOSE 7180 7183 7182 7432 50020 50070 50010 50075 8040 8042 47314 13562 8030 8031 46664 57299 53686 50176 38904
EXPOSE 1004 1006 8020 50470 50090 50495 8485 8480 8032 8033 8088 8041 10020 19888 22 9160 9042

ADD yarn-site.xml /etc/hadoop/conf.empty/
ADD mapred-site.xml /etc/hadoop/conf.empty/
