#!/bin/bash

set -e 
#
#
echo "Info   : Generating textures ${3} with ${1} grains and $2 crystal symmetry "
cd output/
$NEPER -T -n $1\
    -crysym $2 \
    -ori $3 \
    -for ori \
    -o $4 >>neper_log
    
echo "Info   :     [o] Wrote file ../output/$4.ori"
# Read runtime from log file
tail -n 3 neper_log | head -n 1

cd ../imgs/ori
$NEPER -V ../../output/$4.ori\
    -space pf -pfmode symbol \
    -datapointcol black -datapointedgecol white\
    -pfpole 1:0:0 \
    -print ${4}_pf_100 \
    -pfpole 1:1:0 \
    -print ${4}_pf_110 \
    -pfpole 1:1:1 \
    -print ${4}_pf_111 >>neper_log

convert +append ${4}_pf_100.png ${4}_pf_110.png ${4}_pf_111.png ${4}_pf.png

echo "Info   :     [o] Wrote file ../imgs/ori/${4}_pf.png"
# Read runtime from log file
tail -n 3 neper_log | head -n 1
exit 0