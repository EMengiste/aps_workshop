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
#   This script uses helper scripts that are in the same directory and work stand alone
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
#   visualize_ori.sh  => generates figures: 
#                         $1 input tesselation name
#
echo "========================    Work flow script     =======================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
if [ "$#" -eq 0 ]; then 
    echo "Error  : no input provided exiting"
    echo "Info   : ---------------------------------------------------------------"
    echo "Info   : done!"
    echo "========================================================================"
    #
    exit 0
fi
#
num_grains=$1
#
# Set defaults
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


section="Crystallographic Texture"

if [ "${section}" == "Tesselation Generation" ]; then
  echo "Info   : ${section}"
  # ## Generate samples
  # ## inputs are                   num_grains,  morpho,  name
  #                                 # -n       , -morpho, -o
  # ${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_tess
  # ${SCRIPTPATH}/generate_tess.sh $num_grains centroidal centroidal_tess
  ##
  ## User defined spreicity distribution
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.145,0.05)' udef_sphericity_m_0_145_s0_05
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.145,0.10)' udef_sphericity_m_0_145_s0_10
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.145,0.15)' udef_sphericity_m_0_145_s0_15
  #
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.105,0.05)' udef_sphericity_m_0_105_s0_05
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.105,0.10)' udef_sphericity_m_0_105_s0_10
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.105,0.15)' udef_sphericity_m_0_105_s0_15

  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.185,0.05)' udef_sphericity_m_0_185_s0_05
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.185,0.10)' udef_sphericity_m_0_185_s0_10
  ${SCRIPTPATH}/generate_tess.sh $num_grains '1-sphericity:lognormal(0.185,0.15)' udef_sphericity_m_0_185_s0_15
  #
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.145,0.05)' udef_diameq_m_0_145_s0_05
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.145,0.10)' udef_diameq_m_0_145_s0_10
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.145,0.15)' udef_diameq_m_0_145_s0_15
  #
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.105,0.05)' udef_diameq_m_0_105_s0_05
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.105,0.10)' udef_diameq_m_0_105_s0_10
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.105,0.15)' udef_diameq_m_0_105_s0_15

  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.185,0.05)' udef_diameq_m_0_185_s0_05
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.185,0.10)' udef_diameq_m_0_185_s0_10
  ${SCRIPTPATH}/generate_tess.sh $num_grains 'diameq:lognormal(0.185,0.15)' udef_diameq_m_0_185_s0_15
  #
elif [ "${section}" == "Crystallographic Texture" ]; then
  #
  echo "Info   : ${section}"
  # Generate orientations
  # ${SCRIPTPATH}/generate_ori.sh $num_grains cubic 'fiber(0,0,1,0,0,1)' fiber_001_001
  # ${SCRIPTPATH}/generate_ori.sh $num_grains cubic 'fiber(0,1,1,0,0,1)' fiber_011_001
  # ${SCRIPTPATH}/generate_ori.sh $num_grains cubic 'fiber(1,1,1,0,0,1)' fiber_111_001
  # # #
  # ${SCRIPTPATH}/generate_ori.sh $num_grains cubic 'fiber(0,0,1,0,0,1)' fiber_001_001
  # ${SCRIPTPATH}/generate_ori.sh $num_grains cubic 'fiber(0,1,1,0,1,1)' fiber_011_011
  # ${SCRIPTPATH}/generate_ori.sh $num_grains cubic 'fiber(1,1,1,1,1,1)' fiber_111_111
  #
  ${SCRIPTPATH}/generate_ori.sh $num_grains hexagonal 'random' random_hex
  ${SCRIPTPATH}/generate_ori.sh $num_grains cubic 'fiber(0,0,1,0,0,1)' fiber_001_001
 
  # ${SCRIPTPATH}/generate_ori.sh $num_grains hexagonal 'fiber(0,0,1,0,0,1)' fiber_hex_001_001
  # ${SCRIPTPATH}/generate_ori.sh $num_grains hexagonal 'fiber(0,1,1,0,0,1)' fiber_hex_011_001
  # ${SCRIPTPATH}/generate_ori.sh $num_grains hexagonal 'fiber(1,1,1,0,0,1)' fiber_hex_111_001
  ## inputs are                   num_grains,  crysym,  ori, name
  #                              # -n       , -crysym, -ori, -o
  #   Generate  tesselations with cubic crystal symetry and varying orientation distributions
  # ${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_thet_5 "cube:normal(thetam=5)" cubic 
  # ${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_thet_15 "cube:normal(thetam=15)" cubic
  # ${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_thet_25 "cube:normal(thetam=25)" cubic
  # ${SCRIPTPATH}/generate_tess.sh $num_grains gg gg_cube_goss_thet_15 "0.5*cube:normal(thetam=15)+0.5*goss:normal(thetam=15)" cubic
  # #
  #   Visualize the orientations in ipf and pf and rodrigues space
  #
  # #
  # ${SCRIPTPATH}/visualize_orientations.sh gg_cube_thet_5
  # ${SCRIPTPATH}/visualize_orientations.sh gg_cube_thet_15
  # ${SCRIPTPATH}/visualize_orientations.sh gg_cube_thet_25
  # ${SCRIPTPATH}/visualize_orientations.sh gg_cube_goss_thet_15
  # #
  #
elif [ "${section}" == "Meshing" ]; then
  echo "Info   : ${section}"
  ## inputs are                   tess_name, rcl, partition 
  #                              #        , -rcl, -part
  ${SCRIPTPATH}/generate_mesh.sh  gg_tess $rcl $part
  ${SCRIPTPATH}/generate_mesh.sh  centroidal_tess $rcl $part
  ${SCRIPTPATH}/generate_mesh.sh  voronoi_tess $rcl $part
  #
  #
elif [ "${section}" == "Boundary Conditions" ]; then
  echo "Info   : ${section}"
  ##
  # Prepare simulation
  ## inputs are           mesh_file, orifile, partition             BCS
  #                      #        , ori, -part
  ${SCRIPTPATH}/prepare_simulation.sh gg_tess.msh cube.ori 001.cfg 001 $PWD 1 2 # grip
  ${SCRIPTPATH}/prepare_simulation.sh gg_tess.msh cube.ori 002.cfg 002 $PWD 1 2 # minimal
  ${SCRIPTPATH}/prepare_simulation.sh gg_tess.msh cube.ori 003.cfg 003 $PWD 1 2 # symertic
  #
  #
elif [ "${section}" == "Post-processing" ]; then
  echo "Info   : ${section}"
  #
elif [ "${section}" == "Visualization" ]; then
  echo "Info   : ${section}"
  #
fi

echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#
#
exit 0
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
${SCRIPTPATH}/generate_tess.sh $num_grains voronoi voronoi_tess
echo "Info   : ---------------------------------------------------------------"
#

# echo "Info   : ---------------------------------------------------------------"
# #
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