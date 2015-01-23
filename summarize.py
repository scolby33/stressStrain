#!/usr/bin/python

import csv
import os
import re

regex = re.compile(r'elasticStrain \s*\b(\S+)')

with open('summary.csv', 'w') as sumout:
    sumwrite = csv.writer(sumout, lineterminator='\n')
    
    rows = []

    for f in os.listdir(os.getcwd()):
        row = []
        if f.endswith('-summary.txt'):
            with open(f, 'r') as summary:
                row.append(summary.name)
                for line in summary:
                    matches = re.findall(regex, line)
                    if matches:
                        row.append(matches[0])
                rows.append(row)

    sumwrite.writerows(rows)
