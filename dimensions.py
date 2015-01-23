#!/usr/bin/python

import csv
import os

with open('dimensions.csv', 'rU') as dimensionsinput:
    readdims = csv.reader(dimensionsinput, dialect=csv.excel)
    dimensions = {}
    for row in readdims:
        key = row[0]
        dimensions[key] = row[1:]

for f in os.listdir(os.getcwd()):
    if f.endswith('.csv') and not(f == 'dimensions.csv'):
        with open(f, 'r') as datainput:
                with open(os.path.relpath('added/' + datainput.name), 'w') as csvoutput:
                    readdata = csv.reader(datainput)
                    writeout = csv.writer(csvoutput, lineterminator='\n')

                    rows = []
        
                    row = next(readdata)
                    row.append('xsection')
                    row.append('startLen')
                    rows.append(row)
        
                    row = next(readdata)
                    row.append('(mm^2)')
                    row.append('(mm)')
                    rows.append(row)
        
                    row = next(readdata)
                    row.append(float(dimensions[datainput.name][0]) * float(dimensions[datainput.name][2])) 
                    row.append(dimensions[datainput.name][1])
                    rows.append(row)
        
                    for row in readdata:
                        rows.append(row)
        
                    writeout.writerows(rows)
