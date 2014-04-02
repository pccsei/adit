projects = Project.create!([{year: 2008, semester: 'Fall', tickets_open_time: Date.new(2008, 9, 1), tickets_close_time: Date.new(2008, 12, 1), project_type_id: (ProjectType.find_by name: 'Arrow').id, is_active: false, use_max_clients: true},
                            {year: 2009, semester: 'Fall', tickets_open_time: Date.new(2009, 9, 1), tickets_close_time: Date.new(2009, 12, 1), project_type_id: (ProjectType.find_by name: 'Arrow').id, is_active: false, use_max_clients: true},
                            {year: 2010, semester: 'Fall', tickets_open_time: Date.new(2010, 9, 1), tickets_close_time: Date.new(2010, 12, 1), project_type_id: (ProjectType.find_by name: 'Arrow').id, is_active: false, use_max_clients: true},
                            {year: 2011, semester: 'Fall', tickets_open_time: Date.new(2011, 9, 1), tickets_close_time: Date.new(2011, 12, 1), project_type_id: (ProjectType.find_by name: 'Arrow').id, is_active: false, use_max_clients: true},
                            {year: 2012, semester: 'Fall', tickets_open_time: Date.new(2012, 9, 1), tickets_close_time: Date.new(2012, 12, 1), project_type_id: (ProjectType.find_by name: 'Arrow').id, is_active: false, use_max_clients: true},
                            {year: 2013, semester: 'Fall', tickets_open_time: Date.new(2013, 9, 1), tickets_close_time: Date.new(2013, 12, 1), project_type_id: (ProjectType.find_by name: 'Arrow').id, is_active: false, use_max_clients: true},
                            {year: 2010, semester: 'Spring', tickets_open_time: Date.new(2010, 2, 1), tickets_close_time: Date.new(2010, 5, 1), project_type_id: (ProjectType.find_by name: 'Calendar').id, is_active: false, use_max_clients: true},
                            {year: 2011, semester: 'Spring', tickets_open_time: Date.new(2011, 2, 1), tickets_close_time: Date.new(2011, 5, 1), project_type_id: (ProjectType.find_by name: 'Calendar').id, is_active: false, use_max_clients: true},
                            {year: 2012, semester: 'Spring', tickets_open_time: Date.new(2012, 2, 1), tickets_close_time: Date.new(2012, 5, 1), project_type_id: (ProjectType.find_by name: 'Calendar').id, is_active: false, use_max_clients: true},
                            {year: 2013, semester: 'Spring', tickets_open_time: Date.new(2013, 2, 1), tickets_close_time: Date.new(2013, 5, 1), project_type_id: (ProjectType.find_by name: 'Calendar').id, is_active: false, use_max_clients: true}])