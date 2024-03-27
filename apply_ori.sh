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
echo "Info   : Generating textured mesh ${1}  with $2 texture "
# echo $2
cd imgs/msh
name=${1:(0):(-4)}

# $NEPER -V ../../output/$1.msh\
#     -dataelsetcol "ori:file(../../output/$2.ori)"\
#     -dataelsetcolscheme ipf\
#     -print ${name}_msh_$2 >>neper_log

$NEPER -V ../../output/$1.tess\
    -datacellcol "ori:file(../../output/$2.ori)"\
    -datacellcolscheme ipf\
    -print ${name}_tess_$2 >>neper_log
echo "Info   :     [o] Wrote file ../imgs/mesh/${4}_pf.png"
# Read runtime from log file
tail -n 3 neper_log | head -n 1
# #
echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#
exit 0