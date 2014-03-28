import io
import collections

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

for var in 'school_id role first_name last_name email phone box'.split():
    globals()[var] = var

users = [{school_id: 'Anonymous', role: 0, first_name: 'John', last_name: 'Doe', email: 'noreply@faculty.pcci.edu', phone: '000-0000', box: 9999},
         {school_id: '117288', role: 1, first_name: 'Gordon', last_name: 'Badgett', email: 'gbadge5789@students.pcci.edu', phone: '17-6808-1', box: 9999},
         {school_id: '116431', role: 1, first_name: 'Jake', last_name: 'Canipe', email: 'jcanip5463@students.pcci.edu', phone: '17-1303-2', box: 9999},
         {school_id: '116042', role: 1, first_name: 'Stephen', last_name: 'Chappell', email: 'schapp1161@students.pcci.edu', phone: '17-6904-1', box: 9999},
         {school_id: '117751', role: 1, first_name: 'Chris', last_name: 'Chord', email: 'cchord1692@students.pcci.edu', phone: '17-6328-1', box: 9999},
         {school_id: '117567', role: 1, first_name: 'Noah', last_name: 'Conrad', email: 'nconra2202@students.pcci.edu', phone: '17-6510-1', box: 9999},
         {school_id: '116766', role: 1, first_name: 'Zach', last_name: 'Evans', email: 'zevans8222@students.pcci.edu', phone: '17-1403-4', box: 9999},
         {school_id: '114369', role: 1, first_name: 'Alex', last_name: 'Harper', email: 'aharpe1129@students.pcci.edu', phone: '17-1169-2', box: 9999},
         {school_id: '118679', role: 1, first_name: 'James', last_name: 'Miyashita', email: 'jmiyas1311@students.pcci.edu', phone: '17-6727-2', box: 9999},
         {school_id: '115245', role: 1, first_name: 'James', last_name: 'Mulvihill', email: 'jmulvi1261@students.pcci.edu', phone: '17-6308-1', box: 9999},
         {school_id: '117602', role: 1, first_name: 'Dannie', last_name: 'Scull', email: 'dscull4171@students.pcci.edu', phone: '17-1315-1', box: 9999},
         {school_id: '116730', role: 1, first_name: 'Stephen', last_name: 'Weaver', email: 'sweave3686@students.pcci.edu', phone: '17-6622-2', box: 9999},
         {school_id: '115749', role: 1, first_name: 'Koffi', last_name: 'Wodome', email: 'kwodom1512@students.pcci.edu', phone: '17-2111-1', box: 9999},
         {school_id: '116156', role: 1, first_name: 'Rob', last_name: 'Yoder', email: 'ryoder0017@students.pcci.edu', phone: '17-6324-1', box: 9999}]

Job = collections.namedtuple('Job', 'prefix, generator, count')

################################################################################

def main():
    students = Job(b'student_users = User.create!([',
                   generate_user(1, 'students'),
                   1000)
    teachers = Job(b'teacher_users = User.create!([',
                   generate_user(3, 'faculty'),
                   500)
    with open(OUT_PATH, 'wb') as file:
        for prefix, generator, count in students, teachers:
            file.write(prefix)
            first_line = True
            for _ in range(count):
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

def generate_school_id(start=100000, stop=140000):
    while True:
        number = random.randrange(start, stop)
        if number not in generate_school_id._used:
            generate_school_id._used.add(number)
            yield number

def reset():
    generate_school_id._used = {int(user) for user in (
        user[school_id] for user in users) if user.isdigit()}

generate_school_id.reset = reset
del reset
generate_school_id.reset()

def generate_first_name():
    forename_generators = MALE, FEMALE
    while True:
        yield next(random.choice(forename_generators))

def generate_last_name():
    return SURNAME

def generate_email(first_name, last_name, suffix):
    while True:
        email = '{}{}{:04}@{}.pcci.edu'.format(first_name[0],
                                               last_name[:5],
                                               random.randrange(10000),
                                               suffix).lower()
        if email not in generate_email._used:
            generate_email._used.add(email)
            return email

generate_email._used = set()
generate_email.reset = generate_email._used.clear

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
