#!/usr/bin/Rscript

args = commandArgs(TRUE)
rawData = read.csv(args[1], stringsAsFactors=FALSE)

force = as.numeric(rawData[-1, "Load"])
extension = as.numeric(rawData[-1, "Extension"]) # extension = current length - initial length
xsection = as.numeric(rawData[2, "xsection"])
startLen = as.numeric(rawData[2, "startLen"])

stress = force / xsection
strain = extension / startLen

# independant variable: strain
# dependant variable: stress

quartz()
plot(strain, stress, main = args[1], type = "l")
range = identify(strain, stress, n = 2)
garbage = dev.off()

elasticStress = stress[range[1]:range[2]]
elasticStrain = strain[range[1]:range[2]]

lmFit = lm(elasticStress ~ elasticStrain)
sink(paste(getwd(),"/output/", sub(".csv", "", args[1]), "-summary.txt", sep=""))
summary(lmFit)
sink()

pdf(paste(getwd(),"/output/", sub(".csv", "", args[1]), ".pdf", sep = ""))
plot(strain, stress, main = args[1], sub = paste("Range:", range[1], "to", range[2]), type = "l")
points(elasticStrain, elasticStress, type = "l", col = "red")
abline(lmFit, col = "blue")
garbage = dev.off()

pdf(paste(getwd(),"/output/", sub(".csv", "", args[1]), "-diag.pdf", sep=""))
plot(lmFit)
garbage = dev.off()