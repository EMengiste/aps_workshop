#!/bin/bash

echo $1

readarray -t cfg_file < $1
length=${#cfg_file[@]}
for ind in $(seq 0 1 $length)
do
    if [ ${cfg_file[$ind]:(0):(9)} == 'print' ] 
    then 
        echo $ind ${cfg_file[$ind]:(9)}
    else
        echo "bs tourists"
    fi
done

exit 0
