#!/usr/bin/env bash
export pif=`cat /etc/bind/*example*.key | cut -d ' ' -f 7` 
echo "pif=$pif"
sed -i 's%#secret#%'"$pif"'%g' /etc/bind/named.conf.local
