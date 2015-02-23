#!/usr/bin/env bash

# Error status for incorrect usage of a script - eg. : not called with correct parameters
E_USAGE="1"

_this_script_name=$0

function usage() {
  echo "Usage : "
  echo "$_this_script_name [ -f <containers_dirs_file> ] || [ -c '<docker_image_dir1>,docker_image_dir2 ...>' ]"
  echo "Examples : "
  echo "	1) $_this_script_name -f mydocker_images_dirs.txt"
  echo "	2) $_this_script_name -c 'Master,Slave,Cdh5_Hive_Master'"
}

# TODO : ongoing ...
bindVolumes=""
# Get input parameters
while [ $# -gt 0 ] ; do
		case $1 in
		"-n"|"--name")
			if [ $# -eq 1 ]; then
				echo "Missing attribute for $1 option!!!" 
				usage 
				return $E_USAGE
			fi
			container_name=$2
			shift;;
		
		"-i"|"--image-name")
			if [ $# -eq 1 ]; then
				echo "Missing attribute for $1 option!!!" 
				usage
				return $E_USAGE
			fi
			docker_image_name=$2
			shift;;
			
		"-v"|"--volume")
			if [ $# -eq 1 ]; then
				echo "Missing attribute for $1 option!!!"
				usage
				return $E_USAGE
			fi
			
			#Prepare bind volumes
			# add '-v' in front of each volume name
			# Ex : " vol1 vol2 vol3 vol4 " --> " -v vol1 -v vol2 -v vol3 -v vol4"
			bindVolumes="$bindVolumes -v $2"
			shift;;
		*)  echo "Unknown parameter $1"
			usage
			return $E_USAGE;;
		esac
		shift
done

# Check input arguments

if [ -z "$container_name" ];then
	echo "Error! Missing container name. Script will exit ..."
	usage
	exit 1
fi

if [ -z "docker_image_name" ];then
	echo "Error! Missing docker image name. Script will exit ..."
	usage
	exit 1
fi




scripts_dir=`pwd`
base_dir=`dirname $scripts_dir`

cd $base_dir

while read dockerimg_dir ; do
  cd $base_dir/$dockerimg_dir
  IMAGE_BUILD_TAG=`sed -n "/IMAGE_BUILD_TAG=/" Dockerfile | cut -d '=' -f2`
  
  ./shared/build_common.sh -t $IMAGE_BUILD_TAG
 done < $base_dir/mydocker_images_dirs.txt 
  
