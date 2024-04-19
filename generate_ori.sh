#!/bin/bash

set -e 
#
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
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

if [ $2 == "cubic" ]; then

    $NEPER -V "${SCRIPTPATH}/output/rod.tess,${SCRIPTPATH}/output/$4.ori"\
        -datacellcol lightblue \
        -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
        -datapointcol black\
        -datapointtrs 0.8\
        -cameraprojection orthographic -imagesize 500:500 \
        -showcsys 0\
        -cameraangle 13 -print ${4}_rod_space

elif [ $2 == "hexagonal" ]; then

    $NEPER -V "${SCRIPTPATH}/output/rod_hex.tess,${SCRIPTPATH}/output/$4.ori" \
        -datacellcol lightblue \
        -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
        -datapointcol black\
        -datapointtrs 0.8\
        -cameraprojection orthographic -imagesize 500:500 \
        -showcsys 0\
        -cameraangle 24 -print ${4}_rod_space
fi
#
echo "Info   :     [o] Wrote file ../imgs/ori/${4}_pf.png"
# Read runtime from log file
tail -n 3 neper_log | head -n 1
exit 0