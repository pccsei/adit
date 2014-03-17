import io

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
box: {box!r}}},\r\n'

################################################################################

def main():
    students = generate_user(1, 'students')
    teachers = generate_user(2, 'faculty')
    with open(OUT_PATH, 'wb') as file:
        file.write(b'users = User.create!([')
        first_line = True
        for generator in students, teachers:
            for _ in range(3000):
                if first_line:
                    first_line = False
                else:
                    file.write(b' ' * 22)
                file.write(next(generator).encode())
        file.seek(-3, io.SEEK_CUR)
        file.write(b'])')
        file.truncate()

def generate_user(role, email_suffix):
    id_gen = generate_school_id()
    first_gen = generate_first_name()
    last_gen = generate_last_name()
    phone_gen = generate_phone()
    box_gen = generate_box()
    while True:
        school_id = next(id_gen)
        first_name = next(first_gen)
        last_name = next(last_gen)
        email = generate_email(first_name, last_name, email_suffix)
        phone = next(phone_gen)
        box = next(box_gen)
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
