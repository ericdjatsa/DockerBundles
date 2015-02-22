#!/usr/bin/env bash


cd /opt/docker_common_scripts/
for f in *.sh; do . ./$f & done

for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do service $x start ; done
for x in `cd /etc/init.d ; ls hadoop-yarn-*` ; do service $x start ; done

ipaddress=`ifconfig eth0 | perl -n -e 'if (m/inet addr:([\d\.]+)/g) { print $1 }'`
echo "slaveip: $ipaddress"
echo "node manager ui:http://$ipaddress:8042"

