#!/bin/bash

set -e 
echo "Installing dependencies"
###
# linux
#
##
# macos
    #
    # echo brew install gfortran 
    # brew install gfortran 

    # echo brew install make 
    # brew install make 

        # echo brew install libcairo2 
        # brew install libcairo2 

    # echo brew install hwloc 
    # brew install hwloc 

        # echo brew install libhwloc15 
        # brew install libhwloc15 

        # echo brew install openmpi-bin 
        # brew install openmpi-bin 

        # echo brew install openmpi-common 
        # brew install openmpi-common 

        # echo brew install libopenmpi-dev
        # brew install libopenmpi-dev

##
###

# exit 0
echo "Installing FEPX"
destination="../fepx"
cd $destination
# mkdir build
cd build
cmake ../src
make

echo "Installing Neper"
destination="../neper"
## if exists update
cd $destination
mkdir build
cd build
cmake ../src
make

exit 0
