#!/usr/bin/env bash

# First run the startup script of the parent container (eric.djatsa/cdh5hadoopmaster) : 
/opt/startup/master_startup.sh

# Store HDFS namenode in a variable
export HADOOP_NAMENODE="hdfs://master.example.com:8020"

echo "start hive services"
service hive-metastore restart
service hive-server2 restart

rm -f /var/lib/hive/metastore/metastore_db/*.lck

# TODO : quick and dirty workaround to resolve permission errors
# when trying to create databases / tables with root user
su hdfs -c "hadoop fs mkdir -p /user/hive/warehouse"
su hdfs -c "hadoop fs -chmod -R 777 /user/hive/warehouse"
 
echo "Hive now ready to serve your sql queries on Hadoop"