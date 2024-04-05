#!/bin/bash
NEPER="neper"


$NEPER -V simulation.sim\
  -datanodecoo coo \
  -datanodecoofact 2 \
  -step 1\
  -dataelt3dcol stress_eq\
  -dataeltscaletitle "Stress eqv. (MPa)" \
  -dataeltscale 0:1100\
  -showelt3d all\
  -showelt1d "elt3d_shown" \
  -showcsys 0\
  -cameraangle 13\
  -print ${1}_stress_Serial_0\

$NEPER -V simulation.sim\
  -datanodecoo coo \
  -datanodecoofact 2 \
  -step 2\
  -dataelt3dcol stress_eq\
  -dataeltscaletitle "Stress eqv. (MPa)" \
  -dataeltscale 0:1100\
  -showelt3d all\
  -showelt1d "elt3d_shown" \
  -showcsys 0\
  -cameraangle 13\
  -print ${1}_stress_Serial_1\


$NEPER -V simulation.sim\
  -datanodecoo coo \
  -datanodecoofact 2 \
  -step 1\
  -dataelt3dcol stress_eq\
  -dataeltscaletitle "Stress eqv. (MPa)" \
  -dataeltscale 0:1100\
  -showelt3d all\
  -showelt1d "elt3d_shown" \
  -showcsys 0\
  -cameraangle 13\
  -print ${1}_stress_0\
  -step 1\
  -dataelt3dcol stress_eq\
  -dataeltscaletitle "Stress eqv. (MPa)" \
  -print ${1}_stress_1\
exit 0
