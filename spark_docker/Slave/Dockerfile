FROM pti1/hadoopslave:secondversion

MAINTAINER PTI PTI, pti@coco.fr

#
# Add necessary repos for installation
# http://doc.mapr.com/display/MapR/Installing+MapR+Software#InstallingMapRSoftware-mapr_repo
#


ADD proxy.sh /opt/docker_common_scripts/0_proxy.sh
ADD nsupdate.sh /opt/docker_common_scripts/1_proxy.sh
RUN /opt/docker_common_scripts/0_proxy.sh

RUN apt-get update 
RUN apt-get install -q -y --force-yes spark-core spark-master spark-worker spark-history-server spark-python
RUN apt-get install -q -y --force-yes scala

# Install oozie
RUN sudo apt-get install oozie-client


CMD ["/opt/startup.sh"]

