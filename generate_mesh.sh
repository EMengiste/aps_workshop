#!/bin/bash
##
set -e 
#
echo "Info   : Generating mesh of $1.tess with rcl $2 partitioned for $3 processors"
#
cd ../output/
$NEPER -M $1.tess\
        -rcl $2 \
        -part $3 >>neper_log

echo "Info   :     [o] Wrote file ../output/${3}.msh"
# Read runtime from log file
tail -n 3 neper_log | head -n 1

cd ../imgs/msh
name=${1:(0):(-4)}
$NEPER -V ../../output/$1.msh\
    -dataeltcol white\
    -print ${name}msh \
    -dataeltcol part\
    -print ${name}part >>neper_log
    
echo "Info   :     [o] Wrote file ../imgs/msh/${name}msh.png"
echo "Info   :     [o] Wrote file ../imgs/msh/${name}part.png"
# Read runtime from log file
tail -n 3 neper_log | head -n 1

exit 0
