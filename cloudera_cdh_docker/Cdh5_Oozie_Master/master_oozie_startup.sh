#!/usr/bin/env bash

# First run the startup script of the parent container (eric.djatsa/cdh5hadoopmaster) : 
/opt/startup/master_startup.sh

# Store HDFS namenode in a variable
export HADOOP_NAMENODE="hdfs://master.example.com:8020"

# Install Oozie shared Libs in HDFS

su hdfs -c "hadoop fs -mkdir -p $HADOOP_NAMENODE/user/oozie"
su -c "oozie-setup sharelib create -fs $HADOOP_NAMENODE -locallib /usr/lib/oozie/oozie-sharelib-yarn.tar.gz"
su hdfs -c "hadoop fs -chown -R oozie:oozie $HADOOP_NAMENODE/user/oozie"


# Start postres database 
# then start oozie server 
mkdir /var/run/oozie
chown -R oozie:oozie /var/run/oozie
su postgres -c "/etc/init.d/postgresql start" && service oozie start
#By default, Oozie server runs on port 11000 and its URL is http://<OOZIE_HOSTNAME>:11000/oozie

echo "Oozie is now Ready to run your workflows !"

 
