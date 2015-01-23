#!/bin/bash

# stressStrain.sh
# Scott Colby - 2015

# Usage: stressStrain.sh

shopt -s nullglob	# make sure "*.csv" expands to null if no csv's are present

ERROR=0

RSCRIPT=$(which stressStrain.r)
if [ -z $RSCRIPT ]; then
    if [ -a "stressStrain.r" ]; then
        RSCRIPT="./stressStrain.r"
    else
        echo "stressStrain.r not found"
        exit 3
    fi
fi

mkdir -p output	# set up directory structure
mkdir -p done


if which stressStrain.r; then
    RSCRIPT=$(which stressStrain.r)
else
    

if [ -n "$(echo *.csv)" ]
then
	for f in *.csv	# process each data file with R script
	do
		echo "Procesing $f"
		if stressStrain.r $f
        then
            echo "Moving $f to done folder"
		    mv $f done/
        else
            echo "Error processing $f"
            echo "Not moving $f"
            ERROR=1
        fi
	done
else
	echo "No .csv files in folder $1."
	exit 1
fi

if [ "$ERROR" -ne "0"]; then
    echo "Some processing errors occurred. Please see above for more details."
    exit 2
else
    exit 0
fi
