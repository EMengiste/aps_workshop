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
echo "Info   : Processing $1"
cd $1

if [ -d "simulation.sim" ]; then
  echo "Info   : Simulation directory exists."
else
  echo "Info   : Simulation directory does not exists."
  echo "Info   : exiting!"
  echo "========================================================================"
  exit 0
fi
if [ -d "imgs" ]; then
  echo  "Info   : imgs directory exists."
else
  echo "Info   : imgs directory does not exists making."
  mkdir imgs
fi

# # # Add polycrystal simulation elt, elset, and mesh scale variables
$NEPER -S simulation.sim -reselt "!elt_vol,elt_vol:vol" -reselset "stress_eq,strain_eq,vol,ori" -resmesh "stress_eq,strain_eq,vol"

$NEPER -S simulation.sim -orispace $SCRIPTPATH"/output/rod.msh" -resmesh odfn
$NEPER  -S "simulation.sim" -resmesh "!orifieldn(var=stress_eq,theta=10),orifieldn(var=stress_eq,theta=10)"
$NEPER  -S "simulation.sim" -resmesh "!orifieldn(var=strain_eq,theta=10),orifieldn(var=strain_eq,theta=10)"


echo "Info   : Generating mesh plot with element equivalent strain"
$NEPER -V simulation.sim\
  -loop STEP 0 1 2 \
  -step STEP\
  -datanodecoo coo \
  -datanodecoofact 2 \
  -dataelt3dcol strain_eq \
  -dataeltscaletitle "Strain eqv. (-)" \
  -dataeltscale 0.000:0.100\
  -showelt3d all\
  -showelt1d "elt3d_shown" \
  -showcsys 0\
  -cameraangle 13\
  -print imgs/${1}_strain_STEP\
  -showelt3d "y>=0.5" \
  -showelt1d "elt3d_shown" \
  -print imgs/${1}_strain_STEP_int \
  -endloop >neper_log

# Read runtime from log file
tail -n 3 neper_log | head -n 1
echo "Info   : Generating mesh plot with element equivalent stress"
$NEPER -V simulation.sim\
  -loop STEP 0 1 2 \
  -step STEP\
  -datanodecoo coo \
  -datanodecoofact 2 \
  -dataelt3dcol stress_eq\
  -dataeltscaletitle "Stress eqv. (MPa)" \
  -dataeltscale 0:1100\
  -showelt3d all\
  -showelt1d "elt3d_shown" \
  -showcsys 0\
  -cameraangle 13\
  -print imgs/${1}_stress_STEP \
  -showelt3d "y>=0.5" \
  -showelt1d "elt3d_shown" \
  -print imgs/${1}_stress_STEP_int \
  -endloop >neper_log
# Read runtime from log file
tail -n 3 neper_log | head -n 1
#
echo "Info   : Generating density inverse polefigure"
# generate density inverse polefigures for the z direction
$NEPER -V simulation.sim\
      -step 2 \
      -space ipf -pfmode density    \
      -dataelsetscale 0:2\
      -print imgs/density_ipf >neper_log

# Read runtime from log file
tail -n 3 neper_log | head -n 1

echo "Info   : Generating density polefigures for the 100 110 111 poles"
# generate density polefigures for the 100 110 111 poles
$NEPER -V simulation.sim\
      -step 2 \
      -space pf -pfmode density    \
      -dataelsetscale 0:2\
      -pfpole 1:0:0                 \
      -print imgs/density_pf_100   \
      -pfpole 1:1:0                 \
      -print imgs/density_pf_110   \
      -pfpole 1:1:1                 \
      -print imgs/density_pf_111 >neper_log

# Read runtime from log file

# tail -n 3 neper_log | head -n 1

echo "Info   : Generating orientation density in rod space"
$NEPER -V simulation.sim/orispace/rod.msh\
  -loop STEP 0 1 2 \
  -datanodecol "real:file(simulation.sim/results/mesh/odfn/odfn.stepSTEP)" \
  -datanodescaletitle "MRD" \
  -dataeltcol from_nodes \
  -datanodescale 0.0:0.5:1.0:1.5:2.0:2.5:3.0:3.5 \
  -showelt1d all \
  -showcsys 0 \
  -dataelt1drad 0.002 \
  -dataelt3dedgerad 0 \
  -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
  -imagesize 1000:1000 \
  -print imgs/odf-rod_spaceSTEP \
  -endloop >neper_log

# Read runtime from log file
tail -n 3 neper_log | head -n 1
val_name="orifieldn(var=stress_eq,theta=10)"
echo "Info   : Generating orientation averaged equivalent stress plots in rod space"
neper --rcfile none -V simulation.sim/orispace/rod.msh\
  -loop STEP 0 1 2 \
  -datanodecol "real:file(simulation.sim/results/mesh/${val_name}/${val_name}.stepSTEP)" \
  -datanodescaletitle "Stress eqv. (MPa)" \
  -datanodescale 0:1100\
  -dataeltcol from_nodes \
  -showelt3d all\
  -showelt1d all \
  -showcsys 0 \
  -dataelt1drad 0.002 \
  -dataelt3dedgerad 0 \
  -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
  -imagesize 1000:1000 \
  -print imgs/${1}_odf-rod_space_stress_STEP\
  -endloop >neper_log
tail -n 3 neper_log | head -n 1

echo "Info   : Generating orientation averaged equivalent strain plots in rod space"

val_name="orifieldn(var=strain_eq,theta=10)"
neper --rcfile none -V simulation.sim/orispace/rod.msh\
  -loop STEP 0 1 2 \
  -datanodecol "real:file(simulation.sim/results/mesh/${val_name}/${val_name}.stepSTEP)" \
  -datanodescaletitle "Strain eqv. (-)" \
  -datanodescale 0.000:0.100\
  -showelt3d all\
  -dataeltcol from_nodes \
  -showelt1d all \
  -showcsys 0 \
  -dataelt1drad 0.002 \
  -dataelt3dedgerad 0 \
  -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
  -imagesize 1000:1000 \
  -print imgs/${1}_odf-rod_space_strain_STEP\
  -endloop >neper_log

tail -n 3 neper_log | head -n 1
echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#

exit 0