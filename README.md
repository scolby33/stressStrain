#stressStrain
##A set of scripts to quickly calculate the elastic modulus from load-extension data

###`dimensions.py`
    usage: dimensions.py

This is a helper script to add the xsection and startLen columns (as required by `stressStrain.r`--see below) to a number of CSV data file at once. It reads a CSV file in the current directory called `dimensions.csv` with the following format:

Filename	|	xsection	|	startLen	
------------|---------------|--------------
data    	|   data		|	data
data		|	data		|	data		
...			|	...			|   ...

The script then opens all the other CSV files in the current directory and adds the "xsection" and "startLen" column headers, the unit notations ("(mm^2)" and "mm") directly below the headers, and then the correct value for that data file, based on its file name. The processed files saved in the directory "added" beneath the current directory; the original files are left unchanged.

###`stressStrain.sh`
    usage: stressStrain.sh

This script is a wrapper around the `stressStrain.r` script that takes care of running the R process on each data file in the working directory. First, it checks for the existance of `stressStrain.r` on the path or in the current working directory; if it is not found, the script exits with a status of 3. If there are no csv files in the working directory, the script exits with a status of 1.

Presuming `stressStrain.r` is found, the script then creates a new directory in the current working directory called "done" and passes each .csv data file to `stressStrain.r` in turn. If the R script returns with a 0 exit status, it moves the processed data file to the "done" folder. If the R script returns with any other exit status, a note is printed to the console and the data file is not moved. The next remaining csv files in the directory are still processed, however.

Once all files have been processed, the script exits, with a status of 0 if no problems were encountered and a satus of 2 if there were errors with the processing performed by the R script.

###`stressStrain.r`
    usage: ./stressStrain.r dataFile

This tool expects a data file in CSV format. The data in the CSV file should be arranged as follows:

Extension	|	Load		|	xsection	|	startLen
------------|---------------|---------------|------------
*ignored*	|	*ignored*	|	*ignored*	|	*ignored*
data		|	data		|	data		|	data
...			|	...			|				|

Any other columns ought to be ignored by the R script.

This format is similar to that output by Instron tensile/compressive strength testing aparatus. The extension and load values are assumed to be in mm and N, respectively.

The cross-sectional area (in mm^2) and starting length (in mm) of the sample should be manually added to the data file.

The R script reads the data in and plots the entire stress strain curve using the dev.new() device, and waits for the user to select two points that approximately enclose the elastic (linear) region of the curve.

After this selection is made, the R script fits a linear model to this region and outputs the model parameters, a plot showing the original curve and the model, and the model's diagnostic plots to a series of files in the "output" directory under the current working directory with the same base name as the input data file.

The elastic modulus will be the slope of the fitted line and can be found in output/data-summary.txt in the coefficients section. It is the "Estimate" for "elasticStrain".

###`summarize.py`
    usage: summarize.py

This is a quick-and-dirty script created to extract the calculated elastic modulus from a large number of `*-summary.txt` files. When run, it will find the correct "Estimate" in each file whose name ends with "-summary.txt" in the current working directory and save them to a CSV file called `summary.csv`, alongside the name of the file from which the data was extracted. Note, please, that this process will overwrite any existing summary file.

###Installation Notes
These scripts should work unchanged on any Unix-like system, but have only been tested on OS X 10.9.
