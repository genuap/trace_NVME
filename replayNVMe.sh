#!/bin/bash
# prerequisites:
#    Call the script with root access
#    tools: blktrace


# set default variables
green=$(tput setaf 2)
orange=$(tput setaf 3)
reset=$(tput sgr0)
trace_iterations=1

function usage()
{
	echo "Usage: replayNVMe.sh [OPTIONS]"
	echo "Examples: replayNVMe.sh --device=nvme0n1 --iterations=2"
	echo "  -h,   --help                 print help"
	echo
	echo " Arguments"
    echo "  -i,   --iterations		number of iterations to run (default is 1)"	
    echo "  -d,   --device			device mapping without /dev/"	
	echo

}

while [ "$1" != "" ]; do
	if [[ "$1" == *"="* ]]; then
		PARAM=$(echo "$1" | awk -F= '{print $1}')
		VALUE=$(echo "$1" | awk -F= '{print $2}')
	else
		PARAM="$1"
		shift
		VALUE="$1"
	fi
case $PARAM in
		-h | --help)
			usage
			exit
			;;
		-i | --iterations)
			trace_iterations=$VALUE
			;;
		-d | --device)
			trace_device=$VALUE
			;;
		*)
			echo "ERROR: unknown parameter \"$PARAM\""
			usage
			exit 1
			;;
	esac
	shift
done

# exit when there is no filename is specified on the command line
if [[ ${NUMPARAMETERS} -ne 1 ]];  then
	usage 
	exit 1
fi

# check prerequisites
hash blktrace 2>/dev/null || { echo >&2 "blktrace required but not installed" ; exit 1; }



echo "TraceReplay:"
echo "	device under test: \"$trace_device\""
echo "  iterations: \"${trace_iterations}\""
read -p "${green}Do you want to continue Y/N? ${reset}" -n 1 -r
echo
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
	exit 1
fi

#trace_time = hours
btreplay -M $trace_device -F -v -N -I $trace_iterations


