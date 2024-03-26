#!/bin/bash

set -e 
#
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
if [ -z "$5"]
then
  SOURCE_PATH=$SCRIPTPATH
else
  SOURCE_PATH=$5
fi
#
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
echo "Info   : Considering mesh $1 and $2 texture "
echo "Info   :  runnning with config $3 "

if [ -d $4 ]; then
  echo "Info   : Directory exists."
else
  mkdir $4
fi
cd $4
echo "Info   : Preparing simuation at $PWD "
cp ${SOURCE_PATH}/output/$1 ./simulation.msh
cp ${SOURCE_PATH}/output/$2 ./simulation.ori
cp ${SOURCE_PATH}/$3 ./simulation.cfg
cp ${SCRIPTPATH}/run_sim.sh ./
# NUM_NODES 
if [ -z "$6" ]
then
  num_nodes=1
else
  num_nodes=$6
fi
# NUM_PROC
if [ -z "$7" ]
then
  num_procs=2
else
  num_procs=$7
fi
sed -i "s/NUM_NODES/${num_nodes}/g" run_sim.sh
sed -i "s/NUM_PROCS/${num_procs}/g" run_sim.sh
# echo sed -i "s/PROCESS_SCRIPT/'${SCRIPTPATH}'/g" run_sim.sh
echo ${SCRIPTPATH}
sbatch --hint=nomultithread --job-name=run_$4 ./run_sim.sh
echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#

exit 0