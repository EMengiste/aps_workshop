#!/bin/bash

set -e 
## set neper path and runtime configuraiton file
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
#
#   This script will generate simulation inputs tesselation, orientation set, tesselation
#   
#  Arguments:
#  $1 = number of grains
#  $2(optional) = rcl
#  $3(optional) = partition
#
#   This script uses helper functions that are in the same directory to prepare the sections
#   
#   generate_tess.sh  => generates tesselation using:
#                         $1 number of grains (from above)
#                         $2 morphological properties
#                         $3 output name
#                         $4(optional) orientations
#                         $5(optional) crystal symetry
#
#   generate_mesh.sh  => generates mesh using:
#                         $1 input tesselation name
#                         $2 rcl (from above)
#                         $3 partitioning (from above)
#
#   generate_ori.sh  => generates tesselation using
#                         $1 input tesselation name
#                         $2 rcl (from above)
#                         $3 partitioning (from above)
#
num_grains=$1
#
# Generate mesh inputs
if [ -z "$2" ]
then
  rcl=1
else
  rcl=$2
fi
if [ -z "$3" ]
then
  part=48
else
  part=$3
fi
#
if [ -d output ]; then
  echo "Directory exists."
else
    mkdir output
    mkdir imgs
    mkdir imgs/tess
    mkdir imgs/msh
    mkdir imgs/ori
fi

echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
#
${SCRIPTPATH}/visualize_orientations.sh gg_cube_thet_5
${SCRIPTPATH}/visualize_orientations.sh gg_cube_thet_15
${SCRIPTPATH}/visualize_orientations.sh gg_cube_thet_25
${SCRIPTPATH}/visualize_orientations.sh gg_cube_goss_thet_15
#
exit 0
#   Generate  tesselations with cubic crystal symetry and varying orientation distributions
${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_thet_5 "cube:normal(thetam=5)" cubic 
${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_thet_15 "cube:normal(thetam=15)" cubic
${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_thet_25 "cube:normal(thetam=25)" cubic
# #
${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_goss_thet_15 "0.5*cube:normal(thetam=15)+0.5*goss:normal(thetam=15)" cubic
exit 0
#
#
#
#
${SCRIPTPATH}/prepare_simulation.sh gg_tess.msh cube.ori 003.cfg 003 $PWD 1 2 # symertic
sbatch --hint=nomultithread --job-name=proc_003 ${SCRIPTPATH}/process_simulation.sh 003
# exit 0
# ## Generate sample
## inputs are                   num_grains,  morpho,  name
                               # -n       , -morpho, -o
${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_tess
${SCRIPTPATH}/generate_tess.sh $num_grains centroidal centroidal_tess
${SCRIPTPATH}/generate_tess.sh $num_grains voronoi voronoi_tess
echo "Info   : ---------------------------------------------------------------"
## inputs are                   tess_name, rcl, partition 
#                              #        , -rcl, -part
${SCRIPTPATH}/generate_mesh.sh  gg_tess $rcl $part
${SCRIPTPATH}/generate_mesh.sh  centroidal_tess $rcl $part
${SCRIPTPATH}/generate_mesh.sh  voronoi_tess $rcl $part

#
# Generate orientations
## inputs are                   num_grains,  crysym,  ori, name
#                              # -n       , -crysym, -ori, -o
${SCRIPTPATH}/generate_ori.sh $num_grains cubic "random" rand
${SCRIPTPATH}/generate_ori.sh $num_grains cubic "cube:normal(thetam=5)" cube
${SCRIPTPATH}/generate_ori.sh $num_grains cubic "goss:normal(thetam=5)" goss
# echo "Info   : ---------------------------------------------------------------"
# #
echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#
#
exit 0
##
# Prepare simulation
## inputs are           mesh_file, orifile, partition             BCS
#                      #        , ori, -part
${SCRIPTPATH}/prepare_simulation.sh gg_tess.msh cube.ori 001.cfg 001 $PWD 1 2 # grip
${SCRIPTPATH}/prepare_simulation.sh gg_tess.msh cube.ori 002.cfg 002 $PWD 1 2 # minimal
${SCRIPTPATH}/prepare_simulation.sh gg_tess.msh cube.ori 003.cfg 003 $PWD 1 2 # symertic
# Process simulation
## inputs are           mesh_file, orifile, partition 
#                      #        , ori, -part
sbatch --hint=nomultithread --job-name=proc_001 ${SCRIPTPATH}/process_simulation.sh 001
sbatch --hint=nomultithread --job-name=proc_002 ${SCRIPTPATH}/process_simulation.sh 002
sbatch --hint=nomultithread --job-name=proc_003 ${SCRIPTPATH}/process_simulation.sh 003
# Visualize mesh with generated orientations
## inputs are   tess_name, texture name
#              #        , -dataelsetcol ori
${SCRIPTPATH}/apply_ori.sh voronoi_tess cube