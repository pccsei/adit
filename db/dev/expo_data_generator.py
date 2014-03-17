import builtins
import csv
import random
import string
import re
import itertools

from security import *

################################################################################

with open('PCC Sales Contacts Master List S13.csv', newline='') as file:
    file.readline()
    file.readline()
    reader = csv.DictReader(file)
    table = tuple(reader)

def strip_columns(row):
    for key, value in row.items():
        row[key] = '' if value is None else value.strip()

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

TELEPHONE_REGEX = r'\A(17\s*-\s*\d{4}\s*-\s*[1-4]|((\d{3}\s*-\s*){1,2}\d{4})?(\s*[Ee][Xx][Tt]\.?\s*\d{1,7})?)\Z'
PHONE_TRANS = str.maketrans('ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                            '22233344455566677778889999')

def phone_letter_to_number(text):
    return text.upper().replace('EXT.', '\0') \
           .translate(PHONE_TRANS).replace('\0', 'Ext.')

def scrub_telephone(row):
    number = row['Telephone'].replace('?', '').replace(',', '')
    if re.search(TELEPHONE_REGEX, number) is None:
        match = re.search(r'^x(?P<ext>\d{4})$', number)
        if match is not None:
            number = '850-478-8496 Ext. ' + match.groupdict()['ext']
        match = re.search(r'^(?P<num>(\d{3}\s*-\s*){1,2}\d{4})\s*x(?P<ext>\d{1,7})$', number)
        if match is not None:
            number = '{num} Ext. {ext}'.format(**match.groupdict())
        match = re.search(r'^\((?P<area>\d{3})\)\s*(?P<tri>\d{3})\s*-\s*(?P<quad>\d{4})$', number)
        if match is not None:
            number = '{area}-{tri}-{quad}'.format(**match.groupdict())
        number = phone_letter_to_number(number)
        if re.search(TELEPHONE_REGEX, number) is None:
            print('Warning:', repr(row['Telephone']), 'cannot be scrubbed!')
            number = ''
    row['Telephone'] = number

for row in table:
    strip_columns(row)
    extract_contact_parts(row)
    scrub_telephone(row)

pivot = {column: [] for column in table[0]}
for row in table:
    for column, value in row.items():
        pivot[column].append(value)



################################################################################

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

################################################################################

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

################################################################################

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

################################################################################

ZIP = tuple(set(filter(None, pivot['Zip'])))

def generate_zip():
    while True:
        yield random.choice(ZIP)

################################################################################

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

################################################################################

NUMBER_PARTS = {name: set() for name in ('area', 'tri', 'quad', 'ext')}
for number in filter(None, pivot['Telephone']):
    group = re.search(r'\A((?P<area>\d{3})\s*-\s*)?(?P<tri>\d{3})\s*-\s*(?P<quad>\d{4})(\s*[Ee][Xx][Tt]\.?\s*(?P<ext>\d{1,7}))?\Z', number).groupdict()
    for key, value in group.items():
        NUMBER_PARTS[key].add(value)
for name, parts in NUMBER_PARTS.items():
    parts.discard(None)
    NUMBER_PARTS[name] = tuple(parts)

def generate_telephone():
    used = set()
    while True:
        area = ext = ''
        if random.randrange(2):
            area = random.choice(NUMBER_PARTS['area']) + '-'
        tri = random.choice(NUMBER_PARTS['tri']) + '-'
        quad = random.choice(NUMBER_PARTS['quad'])
        if random.randrange(2):
            ext = ' Ext. ' + random.choice(NUMBER_PARTS['ext'])
        number = area + tri + quad + ext
        if number not in used:
            used.add(number)
            yield number

################################################################################

YEARS = set()
for cell in filter(None, itertools.chain(pivot['Arrow'], pivot['Calendar'])):
    YEARS.update(''.join(c for c in cell if c in '1234567890,').split(','))

def generate_years():
    while True:
        if random.randrange(2):
            yield ''
        else:
            yield ','.join(sorted(random.sample(YEARS, random.randint(
                1, len(YEARS))), key=int))

################################################################################

COMMENTS = tuple(set(filter(None, pivot['Comments (Done?)'])))

def generate_comments():
    while True:
        if random.randrange(2):
            yield ''
        else:
            yield random.choice(COMMENTS)

################################################################################

def main():
    row_gen = generate_rows()
    with builtins.open('expo_data.csv', 'w', newline='') as file:
        writer = csv.DictWriter(file, reader.fieldnames)
        writer.writeheader()
        for _ in range(1000):
            writer.writerow(next(row_gen))

def generate_rows():
    name_gen = generate_company_name()
    addr_gen = generate_address()
    city_gen = generate_city_state()
    code_gen = generate_zip()
    repr_gen = generate_contact()
    tele_gen = generate_telephone()
    year_gen = generate_years()
    note_gen = generate_comments()
    while True:
        yield dict(zip(reader.fieldnames, (next(name_gen),
                                           next(addr_gen),
                                           next(city_gen),
                                           next(code_gen),
                                           next(repr_gen),
                                           next(tele_gen),
                                           next(year_gen),
                                           next(year_gen),
                                           next(note_gen))))

################################################################################

if __name__ == '__main__':
    main()
