FROM ubuntu:12.04

#CONTAINER TAG WILL BE : eric.djatsa/ubuntu_12_04
 
MAINTAINER Eric Djatsa , djatsaedy@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# The line below is to solve an issue with Docker's ubuntu which includes a policy-rc.d file that simply returns 101 (not allowed) for any service that tries to start/restart after installation
# See http://monkinetic.com/2014/07/25/docker-openstack-policy-rcd-mysqld
RUN echo "#!/bin/sh" > /usr/sbin/policy-rc.d && echo "exit 0" >> /usr/sbin/policy-rc.d

RUN apt-get update && apt-get install debconf-utils

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -q -y --force-yes \
	apt-utils \
	curl \
	dnsutils \
	inetutils-ping \
	net-tools \
	ruby \
	telnet \
	unzip \
	vim \
	wget 


# install java
RUN apt-get install -y openjdk-7-jdk
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64


# THIS IS TO GET SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd

 
