#!/bin/bash
##
set -e 
#
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
#
echo "Info   : Generating mesh of $1.tess with rcl $2 partitioned for $3 processors"
#
cd output/
echo "Info   : $NEPER "
echo "Info   :     -M $1.tess"
echo "Info   :     -rcl $2 "
echo "Info   :     -part $3"
echo "Info   :     -o name  >>neper_log"
if [ -z "$4" ]
then
    name=${1:(0):(-4)}
else
    name=$4
fi 
$NEPER -M $1.tess\
        -rcl $2 \
        -part $3 \
        -o $name >>neper_log
echo "Info   :     [o] Wrote file ../output/${3}.msh"
# Read runtime from log file
tail -n 3 neper_log | head -n 1

cd ../imgs/msh

$NEPER -V ../../output/$name.msh\
    -dataeltcol white\
    -print ${name}msh \
    -dataeltcol part\
    -print ${name}part >>neper_log
    
echo "Info   :     [o] Wrote file ../imgs/msh/${name}msh.png"
echo "Info   :     [o] Wrote file ../imgs/msh/${name}part.png"
# Read runtime from log file
tail -n 3 neper_log | head -n 1

exit 0
