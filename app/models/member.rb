class Member < ActiveRecord::Base
  belongs_to :users
  belongs_to :projects
  
   # Returns all the member objects of a given project        
   def self.project_members(project)
     self.where("project_id = ? AND is_enabled = 1", project.id)
   end

   # Returns all the student member objects of a given project
   def self.student_members(project, section = "all")
     teachers = User.all_teacher_ids
     if section == "all"
        self.where("project_id = ? AND user_id NOT IN (?)", project.id, teachers)
     else
        self.where("project_id = ? AND section_number = ? AND user_id NOT IN (?)", 
           project.id, section, teachers)
      end
   end
   
   # Returns only the ids of student members for a given project
   def self.student_member_ids(project)
     teachers = User.all_teacher_ids
     self.where("project_id = ? AND user_id NOT IN (?)", project.id, teachers).pluck(:id)
   end
   
   # Returns only the user ids of student members of a given project and an optional section number
   def self.student_members_user_ids(project, section = 0 )
     teachers = User.all_teacher_ids
     if section == 0
        self.where("project_id = ? AND user_id NOT IN (?)", project.id, teachers).pluck(:user_id)
     else
        self.where("project_id = ? AND section_number = ? AND user_id NOT IN (?)", 
           project.id, section, teachers).pluck(:user_id)
     end
   end   
end
