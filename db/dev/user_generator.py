import io

import security
from weighted_strings import *

################################################################################

SURNAME = WeightedNames('names\\surname*.csv', 'Name', 'Number of occurrences')
MALE = WeightedNames('names\\male*.csv', 'Name', 'Approximate Number')
FEMALE = WeightedNames('names\\female*.csv', 'Name', 'Approximate Number')

OUT_PATH = '.\\user_seed.rb'
TEMPLATE = '\
{{school_id: {school_id!r}, \
role: {role!r}, \
first_name: {first_name!r}, \
last_name: {last_name!r}, \
email: {email!r}, \
phone: {phone!r}, \
box: {box!r}, \
major: {major!r}, \
minor: {minor!r}, \
classification: {classification!r}}},\r\n'

################################################################################

with security.open('Sales Managers Reps S13.csv', newline='') as file:
    reader = csv.DictReader(file)
    pivot = {field: [] for field in reader.fieldnames}
    for row in reader:
        for key, value in row.items():
            pivot[key].append(value)

MAJOR = set(filter(None, pivot['Major']))
MINOR = set(filter(None, pivot['Minor']))
CLASS = set(filter(None, pivot['Class']))

def generate_choice(iterable):
    array = tuple(iterable)
    while True:
        yield random.choice(array)

################################################################################

def main():
    students = b'student_users = User.create!([', generate_user(1, 'students')
    teachers = b'teacher_users = User.create!([', generate_user(3, 'faculty')
    with open(OUT_PATH, 'wb') as file:
        for prefix, generator in students, teachers:
            file.write(prefix)
            first_line = True
            for _ in range(500):
                if first_line:
                    first_line = False
                else:
                    file.write(b' ' * len(prefix))
                file.write(next(generator).encode())
            file.seek(-3, io.SEEK_CUR)
            file.write(b'])\r\n\r\n')
        file.seek(-4, io.SEEK_CUR)
        file.truncate()

def generate_user(role, email_suffix):
    id_gen = generate_school_id()
    first_gen = generate_first_name()
    last_gen = generate_last_name()
    phone_gen = generate_phone()
    box_gen = generate_box()
    major_gen = generate_choice(MAJOR)
    minor_gen = generate_choice(MINOR)
    class_gen = generate_choice(CLASS)
    while True:
        school_id = next(id_gen)
        first_name = next(first_gen)
        last_name = next(last_gen)
        email = generate_email(first_name, last_name, email_suffix)
        phone = next(phone_gen)
        box = next(box_gen)
        major = next(major_gen)
        minor = next(minor_gen)
        classification = next(class_gen)
        yield TEMPLATE.format(**locals())

def generate_school_id(start=100000, stop=200000):
    used = set()
    while True:
        number = random.randrange(start, stop)
        if number not in used:
            used.add(number)
            yield number

def generate_first_name():
    while True:
        yield next(random.choice((MALE, FEMALE)))

def generate_last_name():
    yield from SURNAME

def generate_email(first_name, last_name, suffix):
    while True:
        email = '{}{}{:04}@{}.pcci.edu'.format(first_name[0],
                                               last_name[:5],
                                               random.randrange(10000),
                                               suffix).lower()
        if email not in generate_email.used:
            generate_email.used.add(email)
            return email

generate_email.used = set()
generate_email.reset = generate_email.used.clear

def generate_phone():
    used = set()
    while True:
        building = random.randint(1, 6)
        floor = random.randint(1, 9)
        room = random.randrange(30)
        extension = random.randint(1, 4)
        number = '17-{}{}{:02}-{}'.format(building, floor, room, extension)
        if number not in used:
            used.add(number)
            yield number

def generate_box():
    while True:
        yield random.randrange(1000, 3000)

################################################################################

if __name__ == '__main__':
    main()
