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
    def self.student_members(project, section = "all", choice = 1)
      teachers = User.all_teacher_ids
      if choice == 1
        if section == "all"
          self.where("project_id = ? AND user_id NOT IN (?) AND is_enabled", project.id, teachers, 1)
        else
          self.where("project_id = ? AND section_number = ? AND user_id NOT IN (?) AND is_enabled = ?", 
          project.id, section, teachers, 1)
        end
      elsif choice == 2
        if section == "all"
          self.where("project_id = ? AND user_id NOT IN (?) AND is_enabled", project.id, teachers, 0)
        else
          self.where("project_id = ? AND section_number = ? AND user_id NOT IN (?) AND is_enabled = ?", 
          project.id, section, teachers, 0)
        end
      else 
        if section == "all"
          self.where("project_id = ? AND user_id NOT IN (?)", project.id, teachers)
        else
          self.where("project_id = ? AND section_number = ? AND user_id NOT IN (?)", 
          project.id, section, teachers)
        end
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

  def change_student_status(member)
    member.is_enabled ? member.is_enabled = false : member.is_enabled = true
    member.save!
  end
end
