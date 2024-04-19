#!/bin/bash

set -e 
#
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile none" #${SCRIPTPATH}/.neperrc"
#
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
#
cwd=$PWD
#
cd output
# Generate the Rodrigues space fundaments
#
# Arguments:
#   $1 = input file name

if [ -f $1.ori ]; then
    $NEPER -V "rod.tess,$1.ori" -datacellcol lightblue \
        -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
        -datapointcol black\
        -datapointtrs 0.8\
        -cameraprojection orthographic -imagesize 500:500 \
        -showcsys 0\
        -cameraangle 13 -print $cwd/imgs/ori/${1}_rod_space
    # #
    exit 0
    # echo "Info   :     [o] Wrote file output/rod.msh"
    # #
    # $NEPER -V $1.ori\
    #     -datapointcol black -datapointedgecol white\
    #     -space pf -pfmode symbol \
    #     -pfpole 1:0:0 \
    #     -print $cwd/imgs/ori/${1}_pf_100 \
    #     -pfpole 1:1:0 \
    #     -print $cwd/imgs/ori/${1}_pf_110 \
    #     -pfpole 1:1:1 \
    #     -print $cwd/imgs/ori/${1}_pf_111

    $NEPER -V $1.ori\
        -datapointcol black -datapointedgecol white\
        -space 'ipf' -ipfmode symbol \
        -ipfdir 'y:x'\
        -print $cwd/imgs/ori/1_${1}_pf_z

    $NEPER -V $1.ori\
        -datapointcol black -datapointedgecol white\
        -space 'ipf' -ipfmode symbol \
        -ipfdir '-x:z'\
        -print $cwd/imgs/ori/1_${1}_pf_y

    $NEPER -V $1.ori\
        -datapointcol black -datapointedgecol white\
        -space 'ipf' -ipfmode symbol \
        -ipfdir y:z\
        -print $cwd/imgs/ori/1_${1}_pf_x
else 
    $NEPER -T -loadtess $1.tess -for ori 
    # echo "Info   :     [o] Wrote file output/rod.msh"
    $NEPER -V "rod.tess,$1.ori" -datacellcol lightblue \
        -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
        -datapointcol black\
        -datapointtrs 0.8\
        -cameraprojection orthographic -imagesize 500:500 \
        -showcsys 0\
        -cameraangle 13 -print $cwd/imgs/ori/${1}_rod_space
    #
    echo "Info   :     [o] Wrote file output/rod.msh"
    #
    #
    $NEPER -V $1.ori\
        -datapointcol black -datapointedgecol white\
        -space pf -pfmode symbol \
        -pfpole 1:0:0 \
        -print $cwd/imgs/ori/${1}_pf_100 \
        -pfpole 1:1:0 \
        -print $cwd/imgs/ori/${1}_pf_110 \
        -pfpole 1:1:1 \
        -print $cwd/imgs/ori/${1}_pf_111

    $NEPER -V $1.ori\
        -datapointcol black -datapointedgecol white\
        -space ipf -pfmode symbol \
        -ipfdir x:-y \
        -print $cwd/imgs/ori/${1}_pf_z \
        -ipfdir y:-z \
        -print $cwd/imgs/ori/${1}_pf_y\
        -ipfdir z:-x \
        -print $cwd/imgs/ori/${1}_pf_x

fi
# Add orientation space info to sim directory. What this is doing is taking
# the orientations from the polycrystal (mesh) and representing them in
# Rodrigues space, something called an orientation distribution function, or
# ODF.
# Read runtime from log file
exit 0
## for blank rodspace outlines
$NEPER -V "${SCRIPTPATH}/output/rod.tess"\
    -datacellcol lightblue \
    -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
    -datapointcol black\
    -datapointtrs 0.8\
    -cameraprojection orthographic -imagesize 500:500 \
    -showcsys 0\
    -cameraangle 13 -print rod_space_cub

$NEPER -V "${SCRIPTPATH}/output/rod_hex.tess" \
    -datacellcol lightblue \
    -datacelltrs 0.75 -dataedgerad 0.003 -cameracoo 4:4:3 \
    -datapointcol black\
    -datapointtrs 0.8\
    -cameraprojection orthographic -imagesize 500:500 \
    -showcsys 0\
    -cameraangle 24 -print rod_space_hex
exit 0