import csv
import io
import security

################################################################################

OUT_PATH = '.\\ticket_seed.rb'
IN_PATH = '.\\PCC Sales Contacts Master List S13.csv'

TEMPLATE = "\
{{project_id: (Project.where('project_type_id = ? AND year = ?', \
(ProjectType.find_by name: {project_name!r}).id, {project_year!r}).first).id, \
client_id: (Client.find_by business_name: {client_name!r}).id, \
user_id: (User.find_by school_id: 'Anonymous').id, \
priority_id: priority_id}},\r\n"

################################################################################

PROJECT_TYPES = {'Calendar', 'Arrow'}

################################################################################

def main():
    with open(OUT_PATH, 'wb') as out_file:
        out_file.write(b"priority_id = (Priority.find_by name: 'low').id\r\n")
        prefix = b'tickets = Ticket.create!(['
        out_file.write(prefix)
        with security.open(IN_PATH, newline='') as in_file:
            in_file.readline(); in_file.readline()
            first_line = True
            for row in csv.DictReader(in_file):
                strip_all(row)
                for column in PROJECT_TYPES:
                    for year in create_years(row[column]):
                        if first_line:
                            first_line = False
                        else:
                            out_file.write(b' ' * len(prefix))
                        out_file.write(TEMPLATE.format(
                            project_name=column,
                            project_year=year,
                            client_name=client_name(row)).encode())
        out_file.seek(-3, io.SEEK_CUR)
        out_file.write(b'])')
        out_file.truncate()

def strip_all(row):
    for key, value in row.items():
        if value is not None:
            row[key] = value.strip()

def create_years(column):
    if column is not None:
        for value in column.split(','):
            try:
                yield int(value) + 2000
            except ValueError:
                pass

def client_name(row):
    return row['Company Name (print your name)'].replace('é', 'e')

################################################################################

if __name__ == '__main__':
    main()
