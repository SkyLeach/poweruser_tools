#!/usr/bin/env python3
import sys
import os
import calendar
import pprint
import csv

monthsdays = {
    'January'   : 31,  # noqa E203
    'February'  : 29,  # noqa E203
    'March'     : 31,  # noqa E203
    'April'     : 30,  # noqa E203
    'May'       : 30,  # noqa E203
    'June'      : 31,  # noqa E203
    'July'      : 31,  # noqa E203
    'August'    : 31,  # noqa E203
    'September' : 30,  # noqa E203
    'October'   : 31,  # noqa E203
    'November'  : 30,  # noqa E203
    'December'  : 31,  # noqa E203
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
    """days_in_month.

    :param datestring:
    """
    return monthsdays[monthname(datestring)]


def percentage_of_month(minstring, datestring):
    """percentage_of_month.

    Returns a percentage of month based on number of minutes recorded.

    :param minstring:
    String repr of minutes spent
    :param datestring:
    The Audible datestring field.
    """
    return int(minstring)/60/24/days_in_month(datestring)*100


def monthname(datestring):
    """monthname.

    Returns the name of a month, hackstyle

    :param datestring:
    The audible CSV field containing date
    """
    return calendar.month_name[int(datestring.split('-')[0])]


if __name__ == '__main__':
    # check sys.argv[1] for filename
    if len(sys.argv) < 2:
        raise Exception('Missing source data argument')
    filename = os.path.expanduser(sys.argv[1])
    if os.path.exists(filename):
        # ok let's open it and parse the data
        with open(filename, 'r') as csvfile:
            csvreader = csv.DictReader(
                    csvfile, delimiter=',',
                    doublequote=False,
                    quotechar='"',
                    dialect='excel',
                    escapechar='\\')
            csvwriter = csv.DictWriter(
                    sys.stdout,
                    newcols,
                    delimiter=',',
                    doublequote=False,
                    quotechar='"',
                    dialect='excel',
                    escapechar='\\')
            outrow = {}
            for rnum, row in enumerate(csvreader):
                if not rnum:
                    # write headers
                    csvwriter.writerow(dict(
                        list((c, c) for c in newcols)))
                for k in row:
                    if k == 'Length':
                        parts = row[k].split(' ')
                        if len(parts) == 4:
                            outrow[k] = str(int(parts[0]) * 60 + int(parts[2]))
                        elif parts[1].startswith('hr'):
                            outrow[k] = str(int(parts[0]))
                        else:
                            outrow[k] = str(int(parts[0]))
                    else:
                        outrow[k] = row[k]
                outrow['Count Helper'] = '1'
                outrow['Subtotal'] = '=SUBTOTAL(103,F{})'.format(rnum+2)
                outrow['% of Month'] = percentage_of_month(
                        outrow['Length'], row['Purchase Date'])
                outrow['Subtotal % of Month'] = '=H%d*G%d' % (
                        rnum+2, rnum+2)
                outrow['Month Name'] = monthname(row['Purchase Date'])
                csvwriter.writerow(outrow)
