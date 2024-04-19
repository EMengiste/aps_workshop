#!/bin/bash
#
set -e 
#
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
# Create tessellation from FF data
# Use file centvol, which contains the following for each grain:
# centroid_x centroid_y centroid_z volume
#
stage="Pre-def"
ori="Pre-def_ori"
centvol="Pre-def_centvols"
radii="Pre-def_radii"
centroids="Pre-def_centroids"
dom="1.15, 0.47,  1.5"


# $NEPER -T \
#     -n 193 \
#     -domain "cube(${dom})" \
#     -morpho "centroidsize:file(${centvol}),1-sphericity:lognormal(0.145,0.03)"\
#     -morphooptistop eps=1e-1 \
#     -ori "file(${ori})" \
#     -crysym cubic\
#     -reg 1 \
#     -o ${stage}
# #
# # Create a mesh
# #
# $NEPER -M ${stage}.tess \
#     -order 2 \
#     -part 48 \
#     -o ${stage}
# # #

# Visualizations

if [ -d "imgs" ]; then
  echo  "Info   : imgs directory exists."
else
  echo "Info   : imgs directory does not exists making."
  mkdir imgs
fi
# Straight tessellation
$NEPER -V ${stage}.tess \
      -datacellcol ori\
      -datacellcolscheme ipf\
      -cameraangle 15 \
      -print imgs/${stage}_tess
# Tessellation with mesh
$NEPER -V ${stage}.msh \
    -dataelsetcol ori \
    -dataelsetcolscheme ipf\
    -cameraangle 15 \
    -print imgs/${stage}_mesh
# Spheres of equivalent volume, requires:
# - A tessellation of just the domain
# - A file with just the centroids (centroids)
# - A file of the radii of the spheres of equivalent volume to the grains (radii)
$NEPER -T -n 1 \
  -domain "cube(${dom})" \
  -o imgs/${stage}_domain

$NEPER -V ${stage}_domain.tess,${centroids} \
    -datacelltrs 0.7 \
    -datapointrad "real:file(${radii})" \
    -datapointcol id \
    -datapointcolscheme ipf\
    -cameraangle 15 \
    -print imgs/${stage}_spheres
    
exit 0
