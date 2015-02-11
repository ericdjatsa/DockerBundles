#!/usr/bin/env bash

# Format HDFS
#su -c "hdfs namenode -format"
#RUN sudo -u hdfs hdfs namenode -format

cd /opt/docker_common_scripts/
for f in *.sh; do . ./$f & done


# Start Hadoop services
# TODO : see how to limit permissions to hdfs, yarn, ... ( all relevant ) users
su hdfs -c "hadoop fs -chmod -R 1777 /var/lib/hadoop-hdfs"

for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do service $x start ; done
for x in `cd /etc/init.d ; ls hadoop-yarn-*` ; do service $x start ; done

echo "wait for hdfs to be ready"
until hadoop fs -ls /; do
  echo " [ `basename $0` ] hadoop not yet up..."
  sleep 2
done

echo "create hduser user"
useradd -m hduser

# Step 4: Create the HDFS system directories
su hdfs -c "hadoop fs -mkdir /var"
su hdfs -c "hadoop fs -mkdir /var/lib"
su hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs"
su hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache"
su hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred"
su hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred"
su hdfs -c "hadoop fs -mkdir /var/lib/hadoop-hdfs/cache/mapred/mapred/staging"
# TODO : see how to limit permissions to hdfs, yarn, ... ( all relevant ) users
su hdfs -c "hadoop fs -chmod -R 1777 /var/lib/hadoop-hdfs"
su hdfs -c "hadoop fs -chmod 1777 /var/lib/hadoop-hdfs/cache/mapred/mapred/staging"
su hdfs -c "hadoop fs -chown -R mapred /var/lib/hadoop-hdfs/cache/mapred"

 
# Step 5: Verify the HDFS File Structure
su -c "hdfs dfs -ls -R / "

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
su -c "hadoop fs -mkdir -p /user/hduser" hdfs
su -c "hadoop fs -chown hduser:hduser /user/hduser" hdfs

 
ipaddress=`ifconfig eth0 | perl -n -e 'if (m/inet addr:([\d\.]+)/g) { print $1 }'`
echo "resourcemgr ui: http://$ipaddress:50070"
echo "node manager ui:http://$ipaddress:8042"
echo "yarn resource manager ui:http://$ipaddress:8088"


# Install Oozie shared Libs

if [ ! -d "/user/oozie" ];then
  su hdfs -c "hadoop fs -mkdir -p /user/oozie"
  su hdfs -c "hadoop fs -chown oozie:oozie /user/oozie"
  su hdfs -c "oozie-setup sharelib create -fs hdfs://master.example.com:8020 -locallib /usr/lib/oozie/oozie-sharelib-yarn.tar.gz"
fi


# Start oozie server
## Debug for the moment we do not start Oozie
su -c "service oozie start" 
#By default, Oozie server runs on port 11000 and its URL is http://<OOZIE_HOSTNAME>:11000/oozie

#Set OOZIE_URL parameter
export OOZIE_URL=http://localhost:11000/oozie

echo "Handling over to ssh daemon..."
/usr/sbin/sshd -D
