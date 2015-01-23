#!/usr/bin/Rscript

# stressStrain.r
# Scott Colby - 2015

# Usage: stressStrain.r dataFile

args = commandArgs(TRUE)
rawData = read.csv(args[1], stringsAsFactors=FALSE)	# args[1] = data.csv

force = as.numeric(rawData[-1, "Load"])	# extract the relevant data as numeric
extension = as.numeric(rawData[-1, "Extension"]) # extension = current length - initial length
xsection = as.numeric(rawData[2, "xsection"])
startLen = as.numeric(rawData[2, "startLen"])

stress = force / xsection
strain = extension / startLen

# independant variable: strain
# dependant variable: stress

dev.new()	# works for OSX, change for Windows
plot(strain, stress, main = args[1], type = "l")	# plot the stress-strain curve
range = identify(strain, stress, n = 2)	# and allow user to select linear area
garbage = dev.off()	# hide the output of dev.off()

elasticStress = stress[range[1]:range[2]]	# the data points in the selected range
elasticStrain = strain[range[1]:range[2]]	# are from the elastic region of the curve

lmFit = lm(elasticStress ~ elasticStrain)
sink(paste(getwd(),"/output/", sub(".csv", "", args[1]), "-summary.txt", sep="")) # output/data-summary.txt
summary(lmFit)
sink()

pdf(paste(getwd(),"/output/", sub(".csv", "", args[1]), ".pdf", sep = "")) # output/data.pdf
plot(strain, stress, main = args[1], sub = paste("Range:", range[1], "to", range[2]), type = "l")	# plot the whole curve
points(elasticStrain, elasticStress, type = "l", col = "red")	# highlight the selected area
abline(lmFit, col = "blue")	# show the fitted line
garbage = dev.off()

pdf(paste(getwd(),"/output/", sub(".csv", "", args[1]), "-diag.pdf", sep=""))	# output/data-diag.pdf
plot(lmFit)	# save residuals, etc.
garbage = dev.off()
