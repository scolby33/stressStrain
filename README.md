#stressStrain
##A tool to quickly calculate the elastic modulus from load-extension data


###Usage Notes
    usage: ./stressStrain.sh <path>

This tool expects a series of data files in CSV format located in the folder given by <path>. The data in the CSV file should be arranged as follows:

Extension	|	Load		|	xsection	|	startLen
---------------------------------------------------------
*ignored*	|	*ignored*	|	*ignored*	|	*ignored*
data		|	data		|	data		|	data
...			|	...			|				|

Any other columns ought to be ignored by the R script.

This format is similar to that output by Instron tensile/compressive strength testing aparatus.

The cross-sectional area and starting length of the sample should be manually added to the data file.

The bash script will iterate over each CSV file in the input directory and call the R script for each one. The R script then reads the data in and plots the entire stress strain curve using the quartz() device, and waits for the user to select two points that approximately enclose the elastic (linear) region of the curve.

After this selection is made, the R script fits a linear model to this region and outputs the model parameters, a plot showing the original curve and the model, and the model's diagnostic plots to a series of files in the <path>/output/ directory with the same base name as the input data file.

After the R script returns, the bash script passes the next data file and the process starts again. Once all data is processed, the bash script terminates.

###Installation Notes
These scripts should work unchanged on any Unix-like system, but have only been tested on OS X 10.9.