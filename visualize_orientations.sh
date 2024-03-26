#!/bin/bash

set -e 
#
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"
num_grains=$1
#
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
#
#
cd output
# Generate the Rodrigues space fundamental region and a mesh for it.

# neper -T \
#     -n 1 \
#     -domain "rodrigues(cubic)" \
#     -o rod >neper_log

# echo "Info   :     [o] Wrote file output/rod.tess"
# # Read runtime from log file
# tail -n 3 neper_log | head -n 1

neper -M rod.tess \
    -cl 0.1 -for sim >neper_log

# echo "Info   :     [o] Wrote file output/rod.msh"

# Add orientation space info to sim directory. What this is doing is taking
# the orientations from the polycrystal (mesh) and representing them in
# Rodrigues space, something called an orientation distribution function, or
# ODF.

neper -S simulation.sim -orispace fr-cub.msh -resmesh 'odf,odfn'

echo "Info   :     [o] Wrote file output/simulation.sim"
# Read runtime from log file
tail -n 3 neper_log | head -n 1
exit 0