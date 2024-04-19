#!/bin/bash

file="dct-hp"

## set neper path and runtime configuraiton file
##https://stackoverflow.com/a/4774063/23666436
SOURCE=${BASH_SOURCE[0]}
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
NEPER="neper --rcfile ${SCRIPTPATH}/.neperrc"

cd ../dct/dct-hp
${SCRIPTPATH}/generate_mesh.sh ${file}-tess 0.5 48 ${file}

$NEPER -V ${file}-tess.tess 		\
	-showcsys 0 \
	-dataedgerad 0.0005\
	-showedge "domtype!=1"\
	-cameraangle 7					\
	-imagesize 450:900					\
	-print $file-tess			

$NEPER -V ${file}.msh		\
	-showcsys 0 \
	-cameraangle 7					\
	-dataelt1drad 0.00005\
	-dataelt3dedgerad 0.0005\
	-imagesize 450:900					\
	-print $file-msh					
exit 0
# $NEPER -T -n from_morpho					\
# 	  -morpho "tesr:file(${file}.tesr)"			\
# 	  -domain "cylinder(1,.459340,100)"			\
# 	  -morphooptilogval "iter(100),val"			\
# 	  -morphooptistop itermax=1				\
# 	  -o $file-tessini

# #   -morphooptiobjective "surf,sample(min(voxnb,1000))" 	\

# $NEPER -T -n from_morpho					\
#        -morpho "tesr:file(${file}.tesr)"			\
#        -domain "cylinder(1,.459340,100)"			\
#        -morphooptilogval "iter,val,valmin,eps,reps"		\
#        -morphooptistop reps=1e-4				\
#        -morphooptiini coo:centroid,weight:radeq			\
#        -statcell vol						\
#        -o $file-tess
# #    -morphooptiobjective "surf,sample(min(voxnb,min(voxnb*0.1,1000)))" \

# $NEPER -T -loadtesr dct-hp.tesr -statcell y -for ""
# awk '{if ($1>.22967) {print NR}}' dct-hp.stcell > showcells

$NEPER -V ${file}.tesr -datacellcol ori			\
	  -datarptedgerad 0					\
	  -cameraangle 10					\
	  -showtess 0 					    \
	  -cameracoo x:-3:2					\
	  -imagesize 450:900					\
	  -print $file-tesr					\
	  -showcell "file(showcells)"				\
	  -print $file-tesr-h

for f in dct-hp-tessini dct-hp-tess
do
  $NEPER -V $f.tess -datacellcol ori					\
	    -showedge cyl==0					\
	    -dataedgerad 0.001					\
	    -cameraangle 10					\
	    -cameracoo x:-3:2					\
	    -imagesize 450:900					\
	    -print $f						\
	    -showcell "file(showcells)"				\
	    -showedge cell_shown				\
	    -print $f-h
done

exit 0
#
# for fileini in dct-hp-nosample-int-rate.tess
# do
#   if [ "`grep $fileini Iv | wc -l`" == "0" ]
#   then
#     echo $fileini
#     $NEPER -T -n from_morpho					\
# 	   -morpho "tesr:file(${file}.tesr)"			\
# 	   -morphooptiini "$fileini"				\
# 	   -domain "cylinder(1,.459340,100)"			\
# 	   -morphooptiobjective "pts(region=all)"		\
# 	   -morphooptilogtesr dist				\
# 	   -morphooptistop itermax=1				\
# 	   -o trash > /dev/null
#
#     awk  -v file="$fileini" '{all++; if ($1>0) wrong++} END {print file,100-100*wrong/all}' trash.logtesr >> Iv
#     tail -1 Iv
#   fi
# done
#
# exit 0

img="dct-hp-results.png"
convert +append $file-tesr.png $file-tessini.png $file-tess.png $img
convert $img -pointsize 48 -draw "text  20,50 'a'" $img
convert $img -pointsize 48 -draw "text 470,50 'b'" $img
convert $img -pointsize 48 -draw "text 920,50 'c'" $img

exit 0
