#!/bin/bash

set -e 
cd $(dirname "$0")
## set neper path and runtime configuraiton file
SOURCE=${BASH_SOURCE[0]}
##https://stackoverflow.com/a/4774063/23666436
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
num_grains=5
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
# ## Generate sample
## inputs are                   num_grains,  morpho,  name
                               # -n       , -morpho, -o
./generate_tess.sh $num_grains gg gg_tess
./generate_tess.sh $num_grains centroidal centroidal_tess
./generate_tess.sh $num_grains voronoi voronoi_tess
echo "Info   : ---------------------------------------------------------------"
#
# Generate orientations
## inputs are                   num_grains,  crysym,  ori, name
#                              # -n       , -crysym, -ori, -o
./generate_ori.sh $num_grains cubic "random" rand
./generate_ori.sh $num_grains cubic "cube:normal(thetam=5)" cube
./generate_ori.sh $num_grains cubic "goss:normal(thetam=5)" goss
echo "Info   : ---------------------------------------------------------------"
#
# Generate mesh
## inputs are                   tess_name, rcl, partition 
#                              #        , -rcl, -part
./generate_mesh.sh  gg_tess 1 48
./generate_mesh.sh  centroidal_tess 1 48
./generate_mesh.sh  voronoi_tess 1 48
echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#
#
exit 0
