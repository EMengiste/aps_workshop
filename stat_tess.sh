#!/bin/bash

set -e 
#
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
num_grains=$1
#
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
#
#
cd output
$NEPER -T -loadtess $1.tess \
        -statcell sphericity,diameq  #\ 
    
cd ../
python3 ${SCRIPTPATH}/plot_data.py output/$1.stcell ${1}_stat
# Generate the Rodrigues space fundamental region and a mesh for it.
# Read runtime from log file
tail -n 3 neper_log | head -n 1
exit 0