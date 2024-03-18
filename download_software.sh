#!/bin/bash

set -e 
echo "Downloading FEPX"
destination="../fepx"
## if exists update
git clone git@github.com:neperfepx/FEPX.git $destination

echo "Downloading Neper"
destination="../neper"
## if exists update
git clone git@github.com:neperfepx/neper.git $destination

exit 0
