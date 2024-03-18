#!/bin/bash

set -e 
cd $(dirname "$0")

num_grains=100
pwd
# ## Generate sample
## inputs are                   num_grains,  morpho,  name
                               # -n       , -morpho, -o
./generate_tess.sh $num_grains gg gg_tess
./generate_tess.sh $num_grains centroidal centroidal_tess
./generate_tess.sh $num_grains voronoi voronoi_tess
#
# Generate orientations
## inputs are                   num_grains, crysym, ori , name
                               # -n       , -crysym, -ori, -o
./generate_ori.sh $num_grains cubic "random" rand
./generate_ori.sh $num_grains cubic "cube:normal(thetam=5)" cube
./generate_ori.sh $num_grains cubic "goss:normal(thetam=5)" goss
#
exit 0
# ## Generate mesh
## inputs are                    name_tess, rcl, partition
                               #        , -rcl, -part
./generate_mesh.sh  test_tess 1 2


## apply orientaiton