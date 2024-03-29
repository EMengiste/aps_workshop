#!/bin/bash
set -e 
#
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
#
#
echo "Info   : Generating tesselation $3 with $1 grains and morphology $2" 
cd output/
echo "Info   : $NEPER"
echo "Info   :     -T -n $1 "
echo "Info   :     -morpho $2"
echo "Info   :     -reg 1 "
echo "Info   :     -o $3 >neper_log"
$NEPER -T -n $1 \
    -morpho $2\
    -reg 1 \
    -o $3 >neper_log
    
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