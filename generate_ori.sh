#!/bin/bash

set -e 
## set neper path and runtime configuraiton file
NEPER="neper --rcfile $(dirname "$0")/.neperrc"
#
echo $NEPER
#
echo "Generating orentations for "  $1 " grains"$3 
echo "  and" $2 "crystal symmetry "

cd ../output/
$NEPER -T -n $1\
    -crysym $2 \
    -ori $3 \
    -for ori \
    -o $4 >>neper_log
    
echo "Sample generated" $4

cd ../imgs/
$NEPER -V ../output/$4.ori\
    -space pf -pfmode symbol \
    -datapointcol black -datapointedgecol white\
    -pfpole 1:0:0 \
    -print ${4}_pf_100 \
    -pfpole 1:1:0 \
    -print ${4}_pf_110 \
    -pfpole 1:1:1 \
    -print ${4}_pf_111 >>neper_log

convert +append ${4}_pf_100.png ${4}_pf_110.png ${4}_pf_111.png ${4}_pf.png

exit 0