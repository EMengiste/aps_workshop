#!/bin/bash

set -e 
#
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
#
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
#
#
cd output
# Generate the Rodrigues space fundaments


if [ -f $1.ori ]; then
    # echo "Info   :     [o] Wrote file output/rod.msh"
    $NEPER -V "rod.tess,$1.ori" -datacellcol lightblue \
        -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
        -datapointcol black\
        -cameraprojection orthographic -imagesize 500:500 \
        -showcsys 0\
        -cameraangle 13 -print ../imgs/ori/$1
else 
    $NEPER -T -loadtess $1.tess -for ori 
    # echo "Info   :     [o] Wrote file output/rod.msh"
    $NEPER -V "rod.tess,$1.ori" -datacellcol lightblue \
        -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
        -datapointcol black\
        -cameraprojection orthographic -imagesize 500:500 \
        -showcsys 0\
        -cameraangle 13 -print ../imgs/ori/$1

fi
# Add orientation space info to sim directory. What this is doing is taking
# the orientations from the polycrystal (mesh) and representing them in
# Rodrigues space, something called an orientation distribution function, or
# ODF.

echo "Info   :     [o] Wrote file ../imgs/ori/ori1"
# Read runtime from log file
tail -n 3 neper_log | head -n 1
exit 0