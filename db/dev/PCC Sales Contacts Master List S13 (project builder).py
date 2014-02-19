import csv
import io
import collections

################################################################################

OUT_PATH = '.\\project_seed.rb'
IN_PATH = '.\\PCC Sales Contacts Master List S13.csv'

TEMPLATE = '\
{{year: {year!r}, \
semester: {semester!r}, \
tickets_open_time: Date.new({open_year!r}, {open_month!r}, {open_day!r}), \
tickets_close_time: Date.new({close_year!r}, {close_month!r}, {close_day!r}), \
project_type_id: (ProjectType.find_by name: {project_type_name!r}).id, \
is_active: false, \
use_max_clients: true}},\r\n'

ProjectInfo = collections.namedtuple('ProjectInfo', 'semester, open, close')

PROJECT_TYPES = {'Calendar': ProjectInfo('Spring', 2, 5),
                 'Arrow': ProjectInfo('Fall', 9, 12)}

################################################################################

def main():
    years_by_project = {name: set() for name in PROJECT_TYPES}
    with open(IN_PATH, newline='') as in_file:
        for row in csv.DictReader(in_file):
            for name, years in years_by_project.items():
                years.update(create_years(row[name]))
    with open(OUT_PATH, 'wb') as out_file:
        out_file.write(b'projects = Project.create([')
        first_line = True
        for name, years in years_by_project.items():
            for year in years:
                if first_line:
                    first_line = False
                else:
                    out_file.write(b' ' * 27)
                out_file.write(TEMPLATE.format(
                    year=year,
                    semester=PROJECT_TYPES[name].semester,
                    open_year=year,
                    open_month=PROJECT_TYPES[name].open,
                    open_day=1,
                    close_year=year,
                    close_month=PROJECT_TYPES[name].close,
                    close_day=1,
                    project_type_name=name).encode())
        out_file.seek(-3, io.SEEK_CUR)
        out_file.write(b'])')

def create_years(column):
    if column is not None:
        for value in column.split(','):
            try:
                yield int(value) + 2000
            except ValueError:
                pass

################################################################################

if __name__ == '__main__':
    main()
