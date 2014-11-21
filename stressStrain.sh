#!/bin/bash

# stressStrain.sh
# Scott Colby - 2014

## Usage: stressStrain.sh <path>

shopt -s nullglob	# make sure "*.csv" expands to null if no csv's are present

if [ $# -eq 0 ]
then
	echo "usage: $0 <path>"
	echo "Passes each .csv file in <path> to stresStrain.r, then moves the processed"
	echo "data file to <path>/done once complete"
	exit 1
fi

cd $1

mkdir -p output	# set up directory structure
mkdir -p done

if [ -n "$(echo *.csv)" ]
then
	for f in *.csv	# process each data file with R script
	do
		echo "Procesing $f"
		./stresStrain.r $f
		mv $f done/
	done
else
	echo "    No .csv files in folder $1."
	exit 1
fi

exit 0