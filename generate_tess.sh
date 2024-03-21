#!/bin/bash

set -e 
## set neper path and runtime configuraiton file
#
#
echo "Info   : Generating tesselation $3 with $1 grains and morphology $2" 
cd ../output/
$NEPER -T -n $1 \
    -morpho $2\
    -reg 1 \
    -o $3 >neper_log
    
echo "Info   :     [o] Wrote file ../output/${3}.tess"
# Read runtime from log file
tail -n 3 neper_log | head -n 1

cd ../imgs/tess
$NEPER -V ../../output/$3.tess\
    -datacellcol white\
    -print $3 >>neper_log

echo "Info   :     [o] Wrote file ../imgs/tess/${3}.png"
# Read runtime from log file
tail -n 3 neper_log | head -n 1


exit 0