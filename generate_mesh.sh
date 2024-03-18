#!/bin/bash
##
set -e 
## set neper path and runtime configuraiton file
NEPER="neper --rcfile $(dirname "$0")/.neperrc"
#
#
echo "Generating mesh of " $1".tess with rcl " $2 
echo "  partitioned for " $3 "processors"
#

cd ../output/
$NEPER -M $1.tess\
        -rcl $2\
        -part $3 >>neper_log

echo "Mesh generated" $name.msh

cd ../imgs/
name=${1:(0):(3)}
$NEPER -V ../output/$1.msh\
    -dataeltcol white\
    -print $name >>neper_log
    
exit 0