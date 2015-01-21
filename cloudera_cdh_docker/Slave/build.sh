#! /usr/bin/env bash

_this_script_name=$0
# Check input parameter

function usage {
	echo "Usage : "
	echo "$_this_script_name -t <tag>"
}

EXPECTED_NUM_INPUT_PARAMS=1

if [ $# -lt $EXPECTED_NUM_INPUT_PARAMS ];then
	echo "Error missing parameters"
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

./shared/build_common.sh -t $tag