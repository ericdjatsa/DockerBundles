#!/usr/bin/env bash

# Format hdfs
echo "Formating hdfs ..."
sudo -u hdfs hdfs namenode -format

cd /opt/docker_common_scripts/
for f in *.sh; do . ./$f & done

for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do service $x start ; done
for x in `cd /etc/init.d ; ls hadoop-yarn-*` ; do service $x start ; done

echo "wait for hdfs to be ready"
until hadoop fs -ls /; do
  echo hadoop not yet up...
  sleep 2
done

echo "create pascal user"
useradd -m pascal

echo "yarn hdfs config"
su -c "hadoop fs -rm -r /tmp" hdfs
su -c "hadoop fs -mkdir -p /tmp/hadoop-yarn/staging" hdfs
su -c "hadoop fs -chmod -R 777 /tmp/hadoop-yarn/staging" hdfs
su -c "hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate" hdfs
su -c "hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging"  hdfs
su -c "hadoop fs -mkdir -p /var/log/hadoop-yarn"  hdfs
su -c "hadoop fs -chown yarn:mapred /var/log/hadoop-yarn"  hdfs
su -c "hadoop fs -chmod -R 1777 /tmp"  hdfs


echo "create users directories"
su -c "hadoop fs -mkdir -p /user/root" hdfs
su -c "hadoop fs -chown root:root /user/root" hdfs
su -c "hadoop fs -mkdir -p /user/pascal" hdfs
su -c "hadoop fs -chown pascal:pascal /user/pascal" hdfs

echo "start hive services"
service hive-metastore restart
service hive-server2 restart

rm -f /var/lib/hive/metastore/metastore_db/dbex.lck

echo "provide spark-assembly to hdfs"
source /etc/spark/conf/spark-env.sh
su -c "hdfs dfs -mkdir -p /user/spark/share/lib" hdfs
su -c "hdfs dfs -put /usr/lib/spark/assembly/lib/spark-assembly-h*.jar /user/spark/share/lib/spark-assembly.jar" hdfs

 
ipaddress=`ifconfig eth0 | perl -n -e 'if (m/inet addr:([\d\.]+)/g) { print $1 }'`
echo "resourcemgr ui: http://$ipaddress:50070"
echo "node manager ui:http://$ipaddress:8042"
echo "yarn resource manager ui:http://$ipaddress:8088"

echo "to launch spark-shell: MASTER=yarn-client spark-shell"
echo "/usr/lib/spark/bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn-cluster --num-executors 3 /usr/lib/spark/examples/lib/spark-examples*.jar 3"

# Install Oozie shared Libs

if [ ! -d "/user/oozie" ];then
  su -c "hadoop fs -mkdir -p /user/oozie"
  su -c "hdfs hadoop fs -chown oozie:oozie /user/oozie"
  su -c "oozie-setup sharelib create -fs hdfs://master.example.com:8020 -locallib /usr/lib/oozie/oozie-sharelib-yarn.tar.gz"
fi


# Start oozie server
su -c "service oozie start"
#By default, Oozie server runs on port 11000 and its URL is http://<OOZIE_HOSTNAME>:11000/oozie

#Set OOZIE_URL parameter
export OOZIE_URL=http://localhost:11000/oozie


/usr/sbin/sshd -D


