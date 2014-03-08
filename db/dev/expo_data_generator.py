import builtins
import csv
import random
import string

from security import *

def strip_columns(row):
    for key, value in row.items():
        row[key] = '' if value is None else value.strip()
    return row

with builtins.open('original_data.csv', newline='') as file:
    file.readline()
    file.readline()
    table = list(map(strip_columns, csv.DictReader(file)))

def extract_contact_parts(row):
    contact = row['Contact']
    row['contact_fname'] = row['contact_lname'] = row['contact_title'] = ''
    if contact:
        parts = contact.split()
        if parts[0] in {'Mr.', 'Mrs.', 'Dr.', 'Miss'}:
            row['contact_title'] = parts.pop(0)
        assert parts, 'Parts should not be empty!'
        if len(parts) == 1:
            row['contact_fname'] = parts[0]
        else:
            *first_name, last_name = parts
            row['contact_fname'] = ' '.join(first_name)
            row['contact_lname'] = last_name

for row in table:
    extract_contact_parts(row)

pivot = {column: [] for column in table[0]}
for row in table:
    for column, value in row.items():
        pivot[column].append(value)

company_name = set()
for value in pivot['Company Name (print your name)']:
    company_name.update(value.split())
COMPANY_NAME_POOL = set(filter(None, (''.join(filter(
    string.ascii_letters.__contains__, name)) for name in company_name)))

def generate_company_name():
    used = set()
    while True:
        name = ' '.join(random.sample(COMPANY_NAME_POOL, random.randint(2, 5)))
        if name not in used:
            used.add(name)
            yield name

address_number = set()
address_name = set()
for name in pivot['Address']:
    for part in name.split():
        if part.isdigit():
            address_number.add(part)
        elif part.isalpha():
            address_name.add(part)
address_number = tuple(address_number)

def generate_address():
    used = set()
    while True:
        name = '{} {} {}'.format(random.choice(address_number),
                                 *random.sample(address_name, 2))
        if name not in used:
            used.add(name)
            yield name

cities = set()
states = set()
for city_state in pivot['City, State']:
    if ', ' in city_state:
        c, s = city_state.split(', ')
        cities.add(c.strip())
        states.add(s.strip())
CITIES, STATES = tuple(cities), tuple(states)

def generate_city_state():
    while True:
        yield '{}, {}'.format(random.choice(CITIES), random.choice(STATES))

ZIP = tuple(set(filter(None, pivot['Zip'])))

def generate_zip():
    while True:
        yield random.choice(ZIP)

TITLE = tuple({n for n in pivot['contact_title'] if n})
FNAME = tuple({n for n in pivot['contact_fname'] if n.isalpha()})
LNAME = tuple({n for n in pivot['contact_lname'] if n.isalpha()})

def generate_contact():
    used = set()
    while True:
        name = '{} {} {}'.format(random.choice(TITLE),
                                 random.choice(FNAME),
                                 random.choice(LNAME))
        if name not in used:
            used.add(name)
            yield name
