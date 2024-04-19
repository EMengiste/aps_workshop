#!/bin/bash
#
set -e
#
#
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
svs=false
#
echo "==========================     Script   ==========================" 
echo "Info   : Start of Script"
echo "Info   : Starting path "$PWD 
echo "Info   : ---------------------------------------------------------------"
echo "Info   : Processing $1"
# Arguments :
#     $1 = directory
#     $2 = start
#     $3 = incerement
#     $4 = final
#     $5 = name
cd $1
delay=30
if [ -d "gifs" ]; then
  echo  "Info   : gifs directory exists."
else
  echo "Info   : gifs directory does not exists making."
  mkdir gifs
fi
if [ "$svs" == true ]; then
  python3 ${SCRIPTPATH}/prepare_data.py $2 $4 $3
  for i in $(seq $2 $3 $4); do 
    convert +append imgs/${1}_${5}_${i}.png imgs/$i.png svs_${i} 
  done
elif [ "$5" == "strain" ]; then

  convert                                                  \
    -delay $delay                                             \
    $(for i in $(seq $2 $3 $4); do echo imgs/${1}_${5}_${i}.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_${5}.gif ;
  convert                                                  \
    -delay $delay                                             \
    $(for i in $(seq $2 $3 $4); do echo imgs/${1}_${5}_${i}_int.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_${5}_int.gif ;
else

  convert                                                  \
    -delay $delay                                             \
    $(for i in $(seq $2 $3 $4); do echo imgs/${1}_${5}_${i}.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_${5}.gif ;
  convert                                                  \
    -delay $delay                                             \
    $(for i in $(seq $2 $3 $4); do echo imgs/${1}_${5}_${i}_int.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_${5}_int.gif ;
  python3 ${SCRIPTPATH}/prepare_data.py $2 $4 $3
  convert                                                  \
    -delay $delay                                              \
    $(for i in $(seq $2 $3 $4); do echo imgs/svs_${i}.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_svs.gif ;
  convert                                                  \
    -delay $delay                                              \
    $(for i in $(seq $2 $3 $4); do echo imgs/odf-rod_space${i}.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_odf.gif ;
  convert                                                  \
    -delay $delay                                              \
    $(for i in $(seq $2 $3 $4); do echo imgs/odf-rod_space_stress_${i}.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_stress_odf.gif ;
  convert                                                  \
    -delay $delay                                              \
    $(for i in $(seq $2 $3 $4); do echo imgs/odf-rod_space_strain_${i}.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_strain_odf.gif ;

  convert                                                  \
    -delay $delay                                              \
    $(for i in $(seq $2 $3 $4); do echo imgs/odf-rod_space_int${i}.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_int_odf.gif ;
  convert                                                  \
    -delay $delay                                              \
    $(for i in $(seq $2 $3 $4); do echo imgs/odf-rod_space_stress_${i}_int.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_int_stress_odf.gif ;
  convert                                                  \
    -delay $delay                                              \
    $(for i in $(seq $2 $3 $4); do echo imgs/odf-rod_space_strain_${i}_int.png; done) \
    -loop 0                                                \
    gifs/animated_${1}_int_strain_odf.gif ;
fi
# tail -n 3 neper_log | head -n 1 
echo "Info   : ---------------------------------------------------------------"
echo "Info   : done!"
echo "========================================================================"
#

exit 0