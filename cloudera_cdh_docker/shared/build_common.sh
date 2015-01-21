#! /usr/bin/env bash

_this_script_name=$0
# Check input parameter

function usage {
	echo "Usage : "
	echo "$_this_script_name -t <tag to assign to built container>"
	echo "Example : "
	echo "$_this_script_name -t eric:hadoopmaster:v1"
}

EXPECTED_NUM_INPUT_PARAMS=1

if [ $# -lt $EXPECTED_NUM_INPUT_PARAMS ];then
	echo "Error missing parameters"
	usage
	exit 1
fi

tag=""
# Get input parameters
while [ $# -gt 0 ] ; do
		case $1 in
		"-t"|"--tag")
			if [ $# -eq 1 ]; then
				echo "Missing attribute for $1 option!!!" 
				usage 
				return $E_USAGE
			fi
			tag=$2
			shift;;
		*)  echo "Unknown parameter $1"
			usage
			return $E_USAGE;;
		esac
		shift
done

# Check input parameters
if [ -z `tr -s ' ' <<< "$tag"` ];then
	echo "Error a tag name should be provided"
	usage
fi


# CONTEXT

# This docker build script makes use of a workaround in order to support include symbolic links into
# the docker build context.
# The main reason for doing this is because the "shared" symbolic link points to shared config files between Master and Slave docker containers
# so that we avoid duplicating the same files for both types of containers

# the workaround was retrieve from this discussion thread about adding 
# support for symbolic links in docker : 
# https://github.com/docker/docker/issues/6094
# NB : this workaround is It's not suitable for all cases, as if you want to copy a symlink as a symlink, you can't.

# Another solution would be to mount the shared directory locally in each container type folder ( Master, Slave ) as suggested
# in this thread : http://superuser.com/questions/842642/how-to-make-a-symlinked-folder-appear-as-a-normal-folder

# $ cd projects/app1
#$ mkdir shared
# $ sudo mount -o bind ../shared shared/

# That will attach ../shared to ./shared and should be completely transparent to the system. As explained in man mount.



# COMMAND FOR BUILDING THE DOCKER IMAGE

tar -czh . | docker build -t $tag -

#excerpt from tar man page

#-c, --create
#       create a new archive

#-h, --dereference
#       follow symlinks; archive and dump the files they point to

#-z, --gzip, --gunzip --ungzip

unset _this_script_name