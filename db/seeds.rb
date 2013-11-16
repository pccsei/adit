# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#  cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#  Mayor.create(name: 'Emanuel', city: cities.first)
   
   #priorities = Priority.create([{ name: 'green' }, { name: 'yellow'}, { name: 'white'}])
   
   #users = User.create( name: 'Christina Pasiewicz', school_id: '119693', role: 1, section: 1, phone: '17-1157-2' , email: 'eantip0750@students.pcci.edu', parent_id: 'dlunsford' )
   
   #project_types = ProjectType.create([{ name: 'Calendar' }, { name: 'Arrow' }])
   
   #projects = Project.create(year: 2013 , semester: 'Spring', project_type_id: 1, 
    #                         project_start: '25-FEB-2013', project_end: '15-APR-2013', comment: 'This is the true Spring 2013 project',
     #                        max_clients: '5', max_green_clients: '1', max_white_clients: '1', max_yellow_clients: '1', use_max_clients: true)
   #clients = Client.create([{ business_name: ' Papa Johns', address: '510 tiny tim way', email: 'iateyou@pizza.com', contact_name: 'Papa', telephone: '444-444-4444', comment: 'Last chance for pizza', website: "papaj's@coastline.com"}])
             clients = Client.create([{business_name: '10th Avenue Hair Designs', address: '1000 East Cervantes Street', email: '', website: '', contact_name: '', telephone: '433-5207', comment: ''},
                                      {business_name: '32 Degrees Yogurt Bar', address: '5046 Bayou Boulevard', email: '', website: '', contact_name: 'Eric', telephone: '471-2000', comment: ''}])