#!/bin/bash
##
set -e 
## set neper path and runtime configuraiton file
NEPER="neper --rcfile .neperrc"
#
#
echo "Generating mesh of " $1".tess with rcl " $2 
echo "  partitioned for " $3 "processors"
#

$NEPER -M ../output/$1.tess\
        -rcl $2\
        -part ../output/$3 >>neper_log

echo "Mesh generated" $name.msh

name=${1:(0):(3)}
$NEPER -V ../output/$1.msh\
    -dataeltcol white\
    -print ../imgs/$name >>neper_log
    
exit 0