#!/bin/bash

shopt -s nullglob

mkdir -p output
mkdir -p done

if [ -n "$(echo *.csv)" ]
then
	for f in *.csv
	do
		echo "Procesing $f"
		./stress-strain.r $f
		mv $f done/
	done
else
	echo "    No .csv files in folder."
	echo "    Move data files to this folder then try again."
	exit 3
fi
