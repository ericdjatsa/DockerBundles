FROM jenkins

MAINTAINER Eric Djatsa ( eric.djatsayota@amadeus.com ) 

USER root
#Assign password to root user
RUN echo 'root:root' | chpasswd

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

# Install Openssh

RUN apt-get -y update
RUN apt-get -y install apt-utils openssh-server

# Install git
RUN apt-get -y install git

# Install curl
RUN apt-get -y install curl

# Configure ssh 

RUN mkdir /var/run/sshd
RUN mkdir "$JENKINS_HOME"/.ssh && echo '' > "$JENKINS_HOME"/.ssh/authorized_keys

#Provide a password to user jenkins
RUN echo 'jenkins:jenkins' | chpasswd

# ... Add your ssh keys here

# Updating shell to bash
RUN sed -i s#"$JENKINS_HOME":/bin/false#"$JENKINS_HOME":/bin/bash# /etc/passwd

# Additional jenkins scripts
RUN mkdir /opt/jenkins-scripts

# Add script to simplify install of kenkins plugins 
COPY install_jenkins_plugins/install_jenkins_plugin.sh /opt/jenkins-scripts/

RUN chmod -R +x /opt/jenkins-scripts
 
#Expose ssh port
EXPOSE 22


USER jenkins
# Install Jenkins git and docker plugins 
RUN /opt/jenkins-scripts/install_jenkins_plugin.sh git docker-plugin 

ENTRYPOINT ["/usr/local/bin/jenkins.sh &"]
 
