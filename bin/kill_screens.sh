#!/bin/bash

SCREENS=`screen -ls | grep "Detached" | cut -d' ' -f1 | cut -d'(' -f1 |  sed -e 's/^[[:space:]]*//`

for i in $SCREENS
do
    screen -S $i -X quit
    if [ $? -ne "0" ]
    then
        echo "Failed to kill $i"
    else
        echo "Killed screen $i"
    fi
done


