#!/bin/bash

set -e 
## set neper path and runtime configuraiton file
NEPER="neper --rcfile $(dirname "$0")/.neperrc"
#
echo $NEPER
#
echo "Generating tesselation " $3 " with" $1 " grains"
echo "  and morphology " $2 " grains"
cd ../output/
$NEPER -T -n $1 \
    -morpho $2\
    -o $3 >neper_log
    
echo "Sample generated" $3.tess

cd ../imgs/
$NEPER -V ../output/$3.tess\
    -datacellcol white\
    -print $3 >>neper_log

exit 0