Python 3.3.0 (v3.3.0:bd8afb90ebf2, Sep 29 2012, 10:57:17) [MSC v.1600 64 bit (AMD64)] on win32
Type "copyright", "credits" or "license()" for more information.
>>> import csv
>>> def strip_columns(row)
SyntaxError: invalid syntax
>>> def strip_columns(row):
	for key, value in row.items():
		row[key] = '' if value is None else value.strip()
	return row

>>> with open('original_data.csv', newline='') as file:
	file.readline()
	file.readline()
	table = set(map(strip_columns, csv.DictReader(file)))

	
'Selling Project Master Contact List Spring 2013 (PCC Activities Calendar Leads),,,,,,,,\r\n'
',,,,\r\n'
Traceback (most recent call last):
  File "<pyshell#17>", line 4, in <module>
    table = set(map(strip_columns, csv.DictReader(file)))
TypeError: unhashable type: 'dict'
>>> with open('original_data.csv', newline='') as file:
	file.readline()
	file.readline()
	table = list(map(strip_columns, csv.DictReader(file)))

	
'Selling Project Master Contact List Spring 2013 (PCC Activities Calendar Leads),,,,,,,,\r\n'
',,,,\r\n'
>>> len(table)
478
>>> table[-1]
{'Zip': '32504', 'Calendar': '', 'City, State': 'Pensacola, FL', 'Contact': '', 'Arrow': '', 'Address': '5100 North 9th Avenue', 'Telephone': '', 'Company Name (print your name)': "Zorba's (Cordova Mall)", 'Comments (Done?)': 'approved 12'}
>>> 
