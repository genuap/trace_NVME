# trace_NVME
periodic BLKTRACE of NVMe device

/**************************
 *          traceNVME.sh
*/
Used to trace traffic to a block device periodically, over a given timeframe
"Usage: traceNVMe.sh [OPTIONS]"
 "Examples: traceNVMe.sh --device=/dev/nvme0n1 --samplerate=5 --time=1 --output=out.txt"
  this would trace /dev/nvme0n1 for 5sec every minute (samplerate) over 1hr (time) and output to out.txt

Options:
 "  -h,   --help                 print help"
 "  -sr,  --samplerate              sampling rate (seconds per min)"
 "  -th,  --time                    time in hours to sample"
 "  -d,   --device                  device to trace"        
 "  -o,   --output                  output file name"



/**************************
 *          replay.NVMe.sh
 *
*/

Replay trace:
  devide under test
  iterations

 "Usage: replayNVMe.sh [OPTIONS]"
 "Examples: replayNVMe.sh --device=nvme0n1 --iterations=2"
  this would replay the traces in currnet folder captured for device nvem0n1, and replay twice 

Options:
     "  -h,   --help                 print help"
     "  -i,   --iterations          number of iterations to run (default is 1)"     
     "  -d,   --device                      device mapping without /dev/"   

