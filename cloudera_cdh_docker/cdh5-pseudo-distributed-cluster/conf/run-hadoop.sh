#!/bin/bash

# Start mysql service  
# several Hadoop components require a relational DB as backend store, this is the reason why we first start the mysqld daemon before the Hadoop processes
service mysql restart 

# Assign priviledges to root user using the technique explained here : http://ubuntuforums.org/showthread.php?t=1836919 ( post #4)
debian_sys_maint_passwd=`grep password /etc/mysql/debian.cnf  | head -n 1 | cut -d = -f2 | sed 's/[ \t]//'`

mysql -u debian_sys_maint -p$debian_sys_maint_passwd  -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION ; FLUSH PRIVILEGES;" mysql

# Drop the empty user since it may cause errors as explained here : 
# http://stackoverflow.com/questions/10299148/mysql-error-1045-28000-access-denied-for-user-billlocalhost-using-passw
# mysql -u root -e "DROP USER ''@'localhost';" mysql
mysql -u root -proot -e "UPDATE user SET Password=PASSWORD('root') where USER='root';" mysql
mysql -u root -proot -e "FLUSH PRIVILEGES;" mysql

# Now properly start the mysql service
service mysql restart

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


# # init Hive metastore schema . NB : we also set a MySQL user account [ user : hive , pwd : hive ]  
# for Hive to access the metastore
mysql -u root -proot mysql < /etc/hive/conf/my_hive_metastore_init.sql

service hive-metastore start
service hive-server2 start

#create user directories
sudo -u hdfs hadoop fs -mkdir -p /user/root
sudo -u hdfs hadoop fs -chown root:root /user/root

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
