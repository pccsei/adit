class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
   # Returns all the member objects of a given project        
   def self.project_members(project)
     self.where("project_id = ? AND is_enabled = 1", project.id)
   end
   
   def self.get_manager_name(member)
     if member.parent_id
       User.find(member.parent_id).first_name + ' ' + User.find(member.parent_id).last_name
     end
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
   def self.student_members_user_ids(project, section = "all")
     teachers = User.all_teacher_ids
     if section == "all"
        self.where("project_id = ? AND user_id NOT IN (?)", project.id, teachers).pluck(:user_id)
     else
        self.where("project_id = ? AND section_number = ? AND user_id NOT IN (?)", 
           project.id, section, teachers).pluck(:user_id)
     end
   end   
end
