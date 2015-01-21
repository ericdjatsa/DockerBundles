FROM ubuntu:12.04

MAINTAINER PTI PTI, pti@coco.fr


ENV DEBIAN_FRONTEND noninteractive
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

COPY proxy.sh /opt/docker_common_scripts/0_proxy.sh
COPY nsupdate.sh /opt/docker_common_scripts/1_nsupdate.sh

# TODO : below command fails with error : 
# /bin/sh: 1: /opt/docker_common_scripts/0_proxy.sh: Permission denied
# RUN /opt/docker_common_scripts/0_proxy.sh

RUN apt-get update
RUN apt-get install -q -y --force-yes wget curl inetutils-ping telnet net-tools vim htop dnsutils apt-utils ruby

# install java
RUN apt-get install -y openjdk-7-jdk
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# THIS IS TO GET SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd

# hadoop slave install
#add CDH repo
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -
RUN curl http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/cloudera.list > /etc/apt/sources.list.d/cloudera.list

RUN apt-get update

RUN apt-get install -q -y --force-yes hadoop-yarn-nodemanager hadoop-hdfs-datanode hadoop-mapreduce hadoop-client

COPY core-site.xml /etc/hadoop/conf.empty/
COPY yarn-site.xml /etc/hadoop/conf.empty/
COPY mapred-site.xml /etc/hadoop/conf.empty/
COPY hdfs-site.xml /etc/hadoop/conf.empty/

# Install oozie client
RUN apt-get install -y --force-yes oozie-client

EXPOSE 7180 7183 7182 7432 50020 50070 50010 50075 8040 8042 47314 13562 8030 8031 46664 57299 53686 50176 38904

EXPOSE 1004 1006 8020 50470 50090 50495 8485 8480 8032 8033 8088 8041 10020 19888 9160 9042 22

COPY startup.sh /opt/

RUN chmod +x /opt/startup.sh

CMD ["/opt/startup.sh"]


