#!/usr/bin/env python3
import sys
import os
import calendar
import pprint
import csv

monthsdays = {
    'January'   : 31,
    'February'  : 29,
    'March'     : 31,
    'April'     : 30,
    'May'       : 30,
    'June'      : 31,
    'July'      : 31,
    'August'    : 31,
    'September' : 30,
    'October'   : 31,
    'November'  : 30,
    'December'  : 31,
}

newcols = [
    'Download Status',
    'Title',
    'Author',
    'Length',
    'Purchase Date',
    'Count Helper',
    'Subtotal',
    '% of Month',
    'Subtotal % of Month',
    'Month Name',
]

def days_in_month(datestring):
    return monthsdays[monthname(datestring)]

def percentage_of_month(minstring, datestring):
    return int(minstring)/60/24/days_in_month(datestring)*100

def monthname(datestring):
    return calendar.month_name[int(datestring.split('-')[0])]

if __name__ == '__main__':
    # check sys.argv[1] for filename
    if len(sys.argv) < 2: raise Exception('Missing source data argument')
    filename = os.path.expanduser(sys.argv[1])
    if os.path.exists(filename):
        # ok let's open it and parse the data
        with open(filename, 'r') as csvfile:
            csvreader = csv.DictReader(csvfile, delimiter=',',
                doublequote=False, quotechar='"', dialect='excel',
                escapechar='\\')
            csvwriter = csv.DictWriter(sys.stdout, newcols,
                delimiter=',', doublequote=False, quotechar='"',
                dialect='excel', escapechar='\\')
            outrow = {}
            for rnum,row in enumerate(csvreader):
                if not rnum:
                    # write headers
                    csvwriter.writerow(dict([(c,c) for c in newcols]))
                for k in row:
                    if k == 'Length':
                        parts = row[k].split(' ')
                        if len(parts) == 4:
                            outrow[k] = int(parts[0])*60+int(parts[2])
                        else:
                            outrow[k] = int(parts[0]) * 60 if \
                                parts[1].startswith('hr') else \
                                int(parts[0])
                    else:
                        outrow[k] = row[k]
                outrow['Count Helper'] = 1
                outrow['Subtotal'] = '=SUBTOTAL(103,F%d)' % (rnum+2)
                outrow['% of Month'] =
                    percentage_of_month(outrow['Length'],row['Purchase Date'])
                outrow['Subtotal % of Month'] = '=H%d*G%d' % (rnum+2,rnum+2)
                outrow['Month Name'] = monthname(row['Purchase Date'])
                csvwriter.writerow(outrow)
