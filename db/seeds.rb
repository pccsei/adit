# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#  cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#  Mayor.create(name: 'Emanuel', city: cities.first)

   projects = Project.create(year: 2013 , semester: 'Spring', project_type: 'Calendar', 
                             project_start: '25-FEB-2013', project_end: '15-APR-2013', comment: 'This is the true Spring 2013 project',
                             max_clients: '5', max_green_clients: '1', max_white_clients: '1', max_yellow_clients: '1', use_max_clients: true)
   
   # priorities = Priority.create([{ level: 1 , name: 'green' }, { level: 2, name: 'yellow'}, { level: 3, name: 'white'}])
