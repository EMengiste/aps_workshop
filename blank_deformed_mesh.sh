#!/bin/bash

##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
#
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
echo "Info   : Processing $1"
cd $1
echo "Info   : Generating deformed mesh plot"
$NEPER -V simulation.sim\
    -step $2\
    -datanodecoo coo \
    -datanodecoofact 2 \
    -dataelt3dcol white \
    -cameracoo '-9:9:9'\
    -showelt3d all\
    -showelt1d "elt3d_shown" \
    -datacsyscoo '-1:1:0'\
    -cameraangle 17\
    -print ${1}_defromed_step_${2}\
    -step 0\
    -print ${1}_undefromed_step_0



exit 0
