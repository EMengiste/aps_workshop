#!/bin/bash

set -e 
echo "Installing dev_tools"
destination="../neperfepx"
## if exists update
git clone git@github.com:neperfepx/neperfepx.git $destination

exit 0
