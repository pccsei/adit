import csv
import io

################################################################################

OUT_PATH = '.\\client_seed.rb'
IN_PATH = '.\\PCC Sales Contacts Master List S13.csv'

TEMPLATE = '\
{{business_name: {business_name!r}, \
address: {address!r}, \
email: {email!r}, \
telephone: {telephone!r}, \
comment: {comment!r}, \
website: {website!r}, \
zipcode: {zipcode!r}, \
contact_fname: {contact_fname!r}, \
contact_lname: {contact_lname!r}, \
contact_title: {contact_title!r}, \
city: {city!r}, \
state: {state!r}, \
status_id: (Status.find_by status_type: {status_type!r}).id}},\r\n'

class Nil:
    def __repr__(self):
        return 'nil'

################################################################################

def main():
    with open(OUT_PATH, 'wb') as out_file:
        out_file.write(b'clients = Client.create([')
        with open(IN_PATH, newline='') as in_file:
            first_line = True
            for row in csv.DictReader(in_file):
                strip_all(row)
                if first_line:
                    first_line = False
                else:
                    out_file.write(b' ' * 25)
                extract_contact_parts(row)
                extract_city_state(row)
                out_file.write(TEMPLATE.format(
                    business_name=e_to_e(row['Company Name (print your name)']),
                    address=row['Address'],
                    email='',
                    telephone=row['Telephone'],
                    comment=none_to_empty(row['Comments (Done?)']),
                    website='',
                    zipcode=calculate_zipcode(row),
                    contact_fname=row['contact_fname'],
                    contact_lname=row['contact_lname'],
                    contact_title=row['contact_title'],
                    city=row['City'],
                    state=row['State'],
                    status_type=calculate_status(row)).encode())
        out_file.seek(-3, io.SEEK_CUR)
        out_file.write(b'])')

def strip_all(row):
    for key, value in row.items():
        if value is not None:
            row[key] = value.strip()

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

def extract_city_state(row):
    city_state = row['City, State']
    row['City'] = row['State'] = ''
    if city_state:
        row['City'], row['State'] = city_state.split(', ')

def e_to_e(value):
    return value.replace('é', 'e')

def none_to_empty(value):
    return '' if value is None else value

def calculate_zipcode(row):
    try:
        return int(row['Zip'])
    except ValueError:
        return Nil()

def calculate_status(row):
    if row['Company Name (print your name)'].strip().upper().startswith('PCC '):
        return 'In House'
    try:
        comments = row['Comments (Done?)'].lower()
        if 'do not contact' in comments:
            return 'Not Appoved'
        if 'not approved' in comments:
            return 'Not Appoved'
    except AttributeError:
        pass
    return 'Approved'

################################################################################

if __name__ == '__main__':
    main()
