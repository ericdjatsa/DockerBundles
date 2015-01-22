FROM ubuntu:14.04

MAINTAINER Eric Djatsa ( eric.djatsa@amadeus.com )

# this is a non-interactive automated build - avoid some warning messages
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install openssh-server
RUN apt-get -y install git

# Setting openssh
RUN mkdir /var/run/sshd
#RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config

# Adding git user
RUN adduser --system git
# Assign password 'git' to git user
RUN echo 'git:git' | chpasswd
RUN mkdir -p /home/git/.ssh

# Clearing and setting authorized ssh keys
RUN echo '' > /home/git/.ssh/authorized_keys
RUN echo 'First SSH public key' >> /home/git/.ssh/authorized_keys
RUN echo 'Second SSH public key' >> /home/git/.ssh/authorized_keys
# ... Add your ssh keys here

# Updating shell to bash
RUN sed -i s#/home/git:/bin/false#/home/git:/bin/bash# /etc/passwd

# Create a Git  bare repository 
RUN mkdir /home/git/repositories
RUN git init --bare /home/git/repositories/core_project.git

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

