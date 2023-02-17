#!/bin/bash
# prerequisites:
#    Call the script with root access
#    tools: blktrace


# set default variables
green=$(tput setaf 2)
orange=$(tput setaf 3)
reset=$(tput sgr0)

function usage()
{
	echo "Usage: traceNVMe.sh [OPTIONS]"
	echo "Examples: traceNVMe.sh --filename=/dev/nvme0n1 --samplerate=5 --time=1"
	echo "  -h,   --help                 print help"
	echo
	echo " Arguments"
	echo "  -sr,  --samplerate          	sampling rate (seconds per min)"
	echo "  -th,  --time            	time in hours to sample"
      	echo "  -d,   --device			device to trace"	
	echo "  -f,   --filename		output file name"
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
		-f | --filename)
			trace_filename=$VALUE
			NUMPARAMETERS=$((NUMPARAMETERS+1))
			;;
		-sr | --samplerate)
			trace_rate=$VALUE
			;;
		-th | --time)
			trace_time=$VALUE
			;;
		-d  | --device)
			device=$VALUE
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



echo "Trace:"
echo "	device under test: \"$device\""
echo "  sampling rate (sec/min): \"${trace_rate}\""
echo "  sampling time (hours)  : \"${trace_time}\""
echo "	output: \"$trace_filename\""
#estimated time = seconds per min * 60 min per hr * hrs * 3MB per sec
echo "Estimated Log Size: $((trace_rate*60*trace_time*3)) MB"
echo ""
read -p "${green}Do you want to continue Y/N? ${reset}" -n 1 -r
echo
if ! [[ $REPLY =~ ^[Yy]$ ]]; then
	exit 1
fi

#trace_time = hours
while [ $trace_time -ge 1 ]; do
	#each min in the hour (60 total)
	for i in $(seq 1 60);
		do	
			output="$trace_time.$i.$trace_filename"
			echo "blktrace for \"$trace_rate\" sec: $output "
			blktrace -w $trace_rate -d $device -o $output
			sleep $[60-$trace_rate]
		done
		trace_time=$((trace_time-1))
done
