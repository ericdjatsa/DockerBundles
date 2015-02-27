#!/bin/bash
# This script fetches the current external IP Address, writes out an nsupdate file
# Then performs an nsupdate to our remote server of choice
# This script should be placed on a 10 minute crontab
ECHO=$(which echo)
NSUPDATE=$(which nsupdate)
IP=$(ifconfig eth0 | perl -n -e 'if (m/inet addr:([\d\.]+)/g) { print $1 }')
REVERSEIP=$(echo $IP | awk -F . '{print $4"."$3"."$2"."$1}')
host=$(hostname -f)
$ECHO "server dns.example.com" > /tmp/nsupdate
$ECHO "debug yes" >> /tmp/nsupdate
$ECHO "zone example.com." >> /tmp/nsupdate
$ECHO "update delete $host" >> /tmp/nsupdate
$ECHO "update add $host 3600 A $IP" >> /tmp/nsupdate
$ECHO "send" >> /tmp/nsupdate
$ECHO "zone 172.in-addr.arpa" >> /tmp/nsupdate
$ECHO "update add $REVERSEIP.in-addr.arpa. 3600 PTR $host" >> /tmp/nsupdate
$ECHO "send" >> /tmp/nsupdate

echo "lauching nsupdate"
$NSUPDATE -k /etc/bind/K*.key -v /tmp/nsupdate 2>&1

echo "now verify all us ok"
echo "dig:pti"
dig @dns.example.com $host +short 
echo "dig:revpti"
dig @dns.example.com -x $IP +short


