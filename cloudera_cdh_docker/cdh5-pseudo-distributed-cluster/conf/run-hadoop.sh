#!/bin/bash

# Init and start zookeeper
service zookeeper-server init
service zookeeper-server start

service hadoop-hdfs-namenode start
service hadoop-hdfs-datanode start

sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
sudo -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
service hadoop-mapreduce-historyserver start

sudo -u hdfs hadoop fs -mkdir -p /user/hdfs
sudo -u hdfs hadoop fs -chown hdfs /user/hdfs

#init hive
sudo -u hdfs hadoop fs -mkdir -p /user/hive/warehouse
sudo -u hdfs hadoop fs -chown hdfs /user/hive/warehouse

sudo -u hdfs hadoop fs -chmod -R 1777 /user/hive/warehouse

# Start mysql service in safe mode in order to initialize metastore
mysqld --skip-grant-tables &
mysql -u root -e "UPDATE user SET Password=PASSWORD('root') where USER='root';" mysql
mysql -u root -e "FLUSH PRIVILEGES;" mysql
/etc/init.d/mysql stop

# Now properly start the mysql service
sudo service mysql start

# # init Hive metastore schema . NB : we also set a MySQL user account [ user : hive , pwd : hive ]  
# for Hive to use to access the metastore
mysql -u root -proot mysql < my_hive_metastore_init.sql

service hive-metastore start
service hive-server2 start

#create user directories
sudo -u hdfs -hadoop fs -mkdir -p /user/root
sudo -u hdfs hadoop fs -chown root /user/root

#init oozie
sudo -u hdfs hadoop fs -mkdir /user/oozie
sudo -u hdfs hadoop fs -chown oozie:oozie /user/oozie
sudo oozie-setup sharelib create -fs hdfs://localhost:8020 -locallib /usr/lib/oozie/oozie-sharelib-yarn.tar.gz

service oozie start
export OOZIE_URL=http://localhost:11000/oozie

#init spark history server
sudo -u hdfs hadoop fs -mkdir /user/spark
sudo -u hdfs hadoop fs -mkdir /user/spark/applicationHistory
sudo -u hdfs hadoop fs -chown -R spark:spark /user/spark
sudo -u hdfs hadoop fs -chmod 1777 /user/spark/applicationHistory

#init spark shared libraries
#client than can use SPARK_JAR=hdfs://<nn>:<port>/user/spark/share/lib/spark-assembly.jar
sudo -u spark hadoop fs -mkdir -p /user/spark/share/lib 
sudo -u spark hadoop fs -put /usr/lib/spark/lib/spark-assembly.jar /user/spark/share/lib/spark-assembly.jar 

service spark-history-server start

service hue start

sleep 1

# tail log directory
tail -n 1000 -f /var/log/hadoop-*/*.out