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

  # Returns the section number for a given user and project
    def self.get_section_number(student_id, project)
      find_by(project_id: project.id, user_id: student_id).section_number
    end

    # Returns all the student member objects of a given project
    def self.student_members(project, section = "all", choice = 1)
      teachers = User.all_teacher_ids
      if choice == 1
        if section == "all"
          self.where("project_id = ? AND user_id NOT IN (?) AND is_enabled = ?", project.id, teachers, true)
        else
          self.where("project_id = ? AND section_number = ? AND user_id NOT IN (?) AND is_enabled = ?", 
          project.id, section, teachers, 1)
        end
      elsif choice == 2
        if section == "all"
          self.where("project_id = ? AND user_id NOT IN (?) AND is_enabled = ?", project.id, teachers, 0)
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

  # Flip the student's status. Currectly this is only done by pressing the activate/inactivate button on the manage section page.
  def self.change_student_status(member)
    member.is_enabled ? member.is_enabled = false : member.is_enabled = true
    member.save!
  end

  # Set is_enabled to true
  def self.inactivate_student_status(member)
    member.is_enabled = false
    member.save!
  end

  # Set is_enabled to false
  def self.activate_student_status(member)
    member.is_enabled = true
    member.save!
  end

  # Unassign team leader and have all his team members nil
  def self.destroy_team(team_leader, inactivate_team_leader = false)
    # Accept either the user team leader or member team leader
    if team_leader.instance_of?(User)
      team_leader.role = 1
      team_leader.save
      team_leader = Member.find_by(user_id: team_leader)
    else 
      u_team_leader = User.find(team_leader.user_id).role = 1
      u_team_leader.save
    end

    if team_members = Member.where(parent_id: team_leader.user_id)
      team_members.all.each do |m|
        m.parent_id = nil
        m.save
      end
    end
    if inactivate_team_leader
      inactivate_student_status(team_leader)
    end
  end
end
