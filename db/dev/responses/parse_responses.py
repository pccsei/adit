#! /usr/bin/env python3
"""Allow responses from expo survey to be converted into CSV format.

The expo survey data was in a custom format that was difficult to work
with. This program opens responses.txt, parses the data it contains,
and writes out responses.csv for use in a spreadsheet program."""

__author__ = 'Stephen "Zero" Chappell <Noctis.Skytower@gmail.com>'
__date__ = '28 April 2014'
__version__ = 1, 0, 0

################################################################################

import ast
import csv
import datetime
import re

################################################################################

TIME_DICT = re.compile(r'^(?P<time>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} [+-]?\d{4}){(?P<dict>.+)}$', re.MULTILINE)

TIME_FORM = '%Y-%m-%d %H:%M:%S %z'

KEY_VALUE = re.compile(r'"(?P<key>.+?)"=>({" "=>)?(?P<value>".*?(?<!\\)")')

################################################################################

def main():
    with open('responses.txt', 'rt') as file:
        data = file.read()
    rows = tuple(dict(((kv.groupdict()['key'],
                        ast.literal_eval(kv.groupdict()['value']))
           for kv in KEY_VALUE.finditer(td.groupdict()['dict'])),
           time=datetime.datetime.strptime(td.groupdict()['time'], TIME_FORM))
           for td in TIME_DICT.finditer(data))
    field_names = {name for row in rows for name in row.keys()}
    with open('responses.csv', 'wt', encoding='utf_8', newline='') as file:
        writer = csv.DictWriter(file, sorted(field_names))
        writer.writeheader()
        writer.writerows(rows)

################################################################################

if __name__ == '__main__':
    main()
