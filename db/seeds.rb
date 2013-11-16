# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#  cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#  Mayor.create(name: 'Emanuel', city: cities.first)
   
   priorities = Priority.create([{ name: 'green' }, { name: 'yellow'}, { name: 'white'}])
   
   #users = User.create( name: 'Christina Pasiewicz', school_id: '119693', role: 1, section: 1, phone: '17-1157-2' , email: 'eantip0750@students.pcci.edu', parent_id: 'dlunsford' )
   
   project_types = ProjectType.create([{ name: 'Calendar' }, { name: 'Arrow' }])
   
   projects = Project.create(year: 2013 , semester: 'Spring', project_type_id: 1, 
                             project_start: '25-FEB-2013', project_end: '15-APR-2013', comment: 'This is the true Spring 2013 project',
                             max_clients: '5', max_green_clients: '1', max_white_clients: '1', max_yellow_clients: '1', use_max_clients: true)
