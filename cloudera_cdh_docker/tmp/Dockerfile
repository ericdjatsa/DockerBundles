FROM ubuntu:12.04.5

MAINTAINER Eric Djatsa , djatsaedy@gmail.com

ENV DEBIAN_FRONTEND noninteractive
# The line below is to solve an issue with Docker's ubuntu which includes a policy-rc.d file that simply returns 101 (not allowed) for any service that tries to start/restart after installation
# See http://monkinetic.com/2014/07/25/docker-openstack-policy-rcd-mysqld
RUN echo "#!/bin/sh" > /usr/sbin/policy-rc.d && echo "exit 0" >> /usr/sbin/policy-rc.d

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# THIS IS TO GET SSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd

RUN apt-get update &&  apt-get install -y --force-yes \
	apt-utils \
	postgresql=9.1+129ubuntu1 \
	postgresql-contrib=9.1+129ubuntu1

COPY startup.sh /opt/

RUN chmod +x /opt/startup.sh

CMD service ssh start && while true; do sleep 3000; done

#CMD ["sh", "-c", "/usr/sbin/sshd", "-D"]

#CMD ["/opt/startup.sh"]
