#!/bin/bash
set -e 
#
neper_post_processing=false
mesh_plots=true
pf_plots=false
rod_ori_plots=true
rod_stress_plots=true
rod_strain_plots=true
max_stress="310"
max_strain="0.175"
y_cuttoff="0.2"
coo_fact=1.5
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
#
#image settings
settings="-dataelt3dedgerad 0.0000001 "
settings+="-dataelt1drad 0.0015 "
settings+="-cameraangle 13 "
settings+="-imagesize 400:900 "
settings+="-showelt3d all "
settings+="-showelt1d elt3d_shown "
settings+="-showcsys 0 "
#
# Arguments :
#     $1 = directory
#     $2 = start
#     $3 = incerement
#     $4 = final
#
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


if [ "${neper_post_processing}" == true ] 
  then
  # # # Add polycrystal simulation elt, elset, and mesh scale variables
  $NEPER -S simulation.sim \
        -reselt "!elt_vol,elt_vol:vol" \
        -reselset "!stress_eq,!strain_eq,!vol,!ori,stress_eq,strain_eq,vol,ori" \
        -resmesh "!stress_eq,!strain_eq,!vol,stress_eq,strain_eq,vol"
  exit 0
  # # # Add Rodrigues space mesh
  $NEPER -S simulation.sim -orispace $SCRIPTPATH"/output/rod.msh" -resmesh odfn
  # # # Generate orientation averaged equivalent stress and strain values
  $NEPER  -S "simulation.sim" -resmesh "!orifieldn(var=stress_eq,theta=10),orifieldn(var=stress_eq,theta=10)"
  $NEPER  -S "simulation.sim" -resmesh "!orifieldn(var=strain_eq,theta=10),orifieldn(var=strain_eq,theta=10)"
fi

if [ "${mesh_plots}" == true ] 
  then
  echo "Info   : Generating mesh plot with element equivalent strain"
  $NEPER -V simulation.sim\
    -loop STEP $2 $3 $4 \
    -step STEP\
    -datanodecoo coo \
    -datanodecoofact $coo_fact \
    -dataelt3dcol strain_eq \
    -dataeltscaletitle "Strain eqv. (-)" \
    -dataeltscale 0.000:$max_strain\
    $settings\
    -print imgs/${1}_strain_STEP \
    -showelt3d "y>=$y_cuttoff" \
    -showelt1d "elt3d_shown" \
    -print imgs/${1}_strain_STEP_int \
    -endloop >>neper_log
  # Read runtime from log file
  tail -n 3 neper_log | head -n 1
  echo "Info   : Generating mesh plot with element equivalent stress"
  $NEPER -V simulation.sim\
    -loop STEP $2 $3 $4 \
    -step STEP\
    -datanodecoo coo \
    -datanodecoofact $coo_fact \
    -dataelt3dcol stress_eq\
    -dataeltscaletitle "Stress eqv. (MPa)" \
    -dataeltscale 0:$max_stress\
    $settings\
    -print imgs/${1}_stress_STEP \
    -showelt3d "y>=$y_cuttoff" \
    -showelt1d "elt3d_shown" \
    -print imgs/${1}_stress_STEP_int \
    -endloop >>neper_log
  # Read runtime from log file
  tail -n 3 neper_log | head -n 1
  #
fi 

if [ "${pf_plots}" == true ] 
  then
  echo "Info   : Generating density inverse polefigure"
  # generate density inverse polefigures for the z direction
  $NEPER -V simulation.sim\
    -loop STEP $2 $3 $4 \
    -step STEP\
    -space ipf -pfmode density    \
    -dataelsetscale 0:3\
    -print imgs/density_STEP_ipf \
    -endloop >>neper_log

  # Read runtime from log file
  tail -n 3 neper_log | head -n 1

  echo "Info   : Generating density polefigures for the 100 110 111 poles"
  # generate density polefigures for the 100 110 111 poles
  $NEPER -V simulation.sim\
    -loop STEP $2 $3 $4 \
    -step STEP\
        -space pf -pfmode density    \
        -dataelsetscale 0:3\
        -pfpole 1:0:0                 \
        -print imgs/density_STEP_pf_100   \
        -pfpole 1:1:0                 \
        -print imgs/density_STEP_pf_110   \
        -pfpole 1:1:1                 \
        -print imgs/density_STEP_pf_111 \
        -endloop >>neper_log
  # Read runtime from log file
  tail -n 3 neper_log | head -n 1

fi

if [ "${rod_ori_plots}" == true ] 
  then
  echo "Info   : Generating orientation density in rod space"
  $NEPER -V simulation.sim/orispace/rod.msh\
    -loop STEP $2 $3 $4 \
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
    -endloop >>neper_log

  # Read runtime from log file
  tail -n 3 neper_log | head -n 1

  $NEPER -V simulation.sim/orispace/rod.msh\
    -loop STEP $2 $3 $4 \
    -datanodecol "real:file(simulation.sim/results/mesh/odfn/odfn.stepSTEP)" \
    -datanodescaletitle "MRD" \
    -dataeltcol from_nodes \
    -datanodescale 0.0:0.5:1.0:1.5:2.0:2.5:3.0:3.5 \
    -showelt1d all \
    -showcsys 0 \
    -dataelt1drad 0.002 \
    -dataelt3dedgerad 0 \
    -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
    -slicemesh "x=0,y=0,z=0" \
    -showmesh 0 \
    -imagesize 1000:1000 \
    -print imgs/odf-rod_space_intSTEP \
    -endloop >>neper_log
    # # Read runtime from log file
    tail -n 3 neper_log | head -n 1

fi


if [ "${rod_stress_plots}" == true ] 
  then
  val_name="orifieldn(var=stress_eq,theta=10)"
  echo "Info   : Generating orientation averaged equivalent stress plots in rod space"
  neper --rcfile none -V simulation.sim/orispace/rod.msh\
    -loop STEP $2 $3 $4 \
    -datanodecol "real:file(simulation.sim/results/mesh/${val_name}/${val_name}.stepSTEP)" \
    -datanodescaletitle "Stress eqv. (MPa)" \
    -datanodescale 0:$max_stress\
    -dataeltcol from_nodes \
    -showelt3d all\
    -showelt1d all \
    -showcsys 0 \
    -dataelt1drad 0.002 \
    -dataelt3dedgerad 0 \
    -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
    -imagesize 1000:1000 \
    -print imgs/odf-rod_space_stress_STEP\
    -endloop >>neper_log

  # Read runtime from log file
  tail -n 3 neper_log | head -n 1

  neper --rcfile none -V simulation.sim/orispace/rod.msh\
    -loop STEP $2 $3 $4 \
    -datanodecol "real:file(simulation.sim/results/mesh/${val_name}/${val_name}.stepSTEP)" \
    -datanodescaletitle "Stress eqv. (MPa)" \
    -datanodescale 0:$max_stress\
    -dataeltcol from_nodes \
    -showelt3d all\
    -showelt1d all \
    -showcsys 0 \
    -dataelt1drad 0.002 \
    -dataelt3dedgerad 0 \
    -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
    -slicemesh "x=0,y=0,z=0" \
    -showmesh 0 \
    -imagesize 1000:1000 \
    -print imgs/odf-rod_space_stress_STEP_int\
    -endloop >>neper_log

  # Read runtime from log file
  tail -n 3 neper_log | head -n 1

fi

if [ "${rod_strain_plots}" == true ] 
  then
  echo "Info   : Generating orientation averaged equivalent strain plots in rod space"

  val_name="orifieldn(var=strain_eq,theta=10)"
  neper --rcfile none -V simulation.sim/orispace/rod.msh\
    -loop STEP $2 $3 $4 \
    -datanodecol "real:file(simulation.sim/results/mesh/${val_name}/${val_name}.stepSTEP)" \
    -datanodescaletitle "Strain eqv. (-)" \
    -datanodescale 0:$max_strain\
    -showelt3d all\
    -dataeltcol from_nodes \
    -showelt1d all \
    -showcsys 0 \
    -dataelt1drad 0.002 \
    -dataelt3dedgerad 0 \
    -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
    -imagesize 1000:1000 \
    -print imgs/odf-rod_space_strain_STEP\
    -endloop >>neper_log

  # Read runtime from log file
  tail -n 3 neper_log | head -n 1

  neper --rcfile none -V simulation.sim/orispace/rod.msh\
    -loop STEP $2 $3 $4 \
    -datanodecol "real:file(simulation.sim/results/mesh/${val_name}/${val_name}.stepSTEP)" \
    -datanodescaletitle "Strain eqv. (-)" \
    -datanodescale 0:$max_strain\
    -showelt3d all\
    -dataeltcol from_nodes \
    -showelt1d all \
    -showcsys 0 \
    -dataelt1drad 0.002 \
    -dataelt3dedgerad 0 \
    -cameracoo 4:4:3 -cameraprojection orthographic -cameraangle 13\
    -slicemesh "x=0,y=0,z=0" \
    -showmesh 0 \
    -imagesize 1000:1000 \
    -print imgs/odf-rod_space_strain_STEP_int\
    -endloop >>neper_log

  # Read runtime from log file
  tail -n 3 neper_log | head -n 1
fi

# tail -n 3 neper_log | head -n 1
echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#

exit 0