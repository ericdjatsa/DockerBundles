./0_startdns.sh
# Get current dir
current_dir=`pwd`
# get Parent current_dir
parent_dir=`dirname $current_dir`

./startnode.sh -n master -i eric.djatsa/cdh5hadoopmaster_oozie -v $parent_dir/common_volume:/opt/common_volume

./startnode.sh -n slave1 -i eric.djatsa/cdh5hadoopslave_oozie -v $parent_dir/common_volume:/opt/common_volume
